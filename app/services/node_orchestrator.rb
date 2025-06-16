require "rhelm/client"
require "tempfile"

class NodeOrchestrator
  RELEASE_PREFIX = Rails.env.production? ? "anvil-" : "anvil-"+Rails.env+"-"

  attr_reader :cli

  def initialize(path:, node_id:, account_id:, arguments: {})
    @release = RELEASE_PREFIX + node_id.to_s
    @logger = ActiveSupport::TaggedLogging.
      new(Rails.logger).
      tagged("NodeOrchestrator( #{account_id}, #{node_id} )")
    @logger.info "Initialize with #{arguments}"
    @values = {}.merge(
      path: path,
      host: ApplicationConfig.node_host,

      extraArguments: ApplicationConfig.anvil_arguments + arguments,

      image: {
        repository: ApplicationConfig.anvil_repository,
        tag: ApplicationConfig.anvil_tag,
        pullPolicy: ApplicationConfig.anvil_pull_policy
      },

      ingress: {
        tls: {
          secretName: ApplicationConfig.tls_secret_name
        },
        extraAnnotations: {
          "cert-manager.io/cluster-issuer" => ApplicationConfig.cluster_issuer
        }
      },
      extraLabels: {
        "vilna.blockberry.com/nodeId" => node_id.to_s,
        "vilna.blockberry.com/accountId" => account_id.to_s,
        "vilna.blockberry.com/version" => AppVersion.to_s
      }
    ).deep_stringify_keys

    @values.deep_merge!(
      ingress: {
        extraAnnotations: {
          "cert-manager.io/cluster-issuer" => ApplicationConfig.cluster_issuer
        }
      }
    ) if ApplicationConfig.cluster_issuer.present?

    args = {
      create_namespace: ApplicationConfig.kube_create_namespace,
      namespace: ApplicationConfig.kube_namespace,
      kube_as_user: ApplicationConfig.kube_as_user,
      kube_as_group: ApplicationConfig.kube_as_group
    }
    if ApplicationConfig.kube_token.present?
      args.merge!(
        kube_token: ApplicationConfig.kube_token,
        kube_apiserver: ApplicationConfig.kube_apiserver,
      )
    elsif ApplicationConfig.kubeconfig.present?
      args.merge! kubeconfig: ApplicationConfig.kubeconfig
    end
    @cli = Rhelm::Client.new(logger: @logger, **args)
    @set_options = nil
  end

  def install
    logger.info "install"
    with_values do |values_path|
      cli
        .install(release, ApplicationConfig.chart_dir,
                 wait: true,
                 timeout: ApplicationConfig.helm_timeout,
                 set: set_options,
                 values: values_path)
        .run
    end
  end

  def upgrade
    logger.info "upgrade"
    with_values do |values_path|
      cli
        .upgrade(release, ApplicationConfig.chart_dir, set: set_options, values: values_path)
        .run
    end
  end

  def uninstall
    logger.info "uninstall"
    cli.uninstall(release).run
  end

  def status
    cli
      .status(release)
      .run
  end

  def exists?
    cli
      .status(release)
      .exists?
  end

  private

  attr_reader :release, :values, :set_options, :logger

  def with_values(&block)
    file = Tempfile.new(release + "-values.yaml")
    file.write values.to_yaml
    file.close
    block.call file.path
  ensure
    file&.unlink
  end
end
