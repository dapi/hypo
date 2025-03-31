require "rhelm/client"
require "tempfile"

class NodeOrchestrator
  RELEASE_PREFIX = "anvil-"

  attr_reader :cli

  def initialize(path:, node_id:, account_id:, values: {})
    @release = RELEASE_PREFIX + node_id.to_s
    @values = values.merge(
      path: path,
      host: ApplicationConfig.node_host,
      # Пока не используем
      # ingress: {
      # tls: {
      # secretName: ApplicationConfig.tls_secret_name
      # }
      # },
      extraLabels: {
        "vilna.blockberry.com/nodeId" => node_id.to_s,
        "vilna.blockberry.com/accountId" => account_id.to_s,
        "vilna.blockberry.com/version" => AppVersion.to_s
      }
    ).deep_stringify_keys
    args = {
      namespace: ApplicationConfig.kube_namespace,
      kube_as_user: ApplicationConfig.kube_as_user,
      kube_as_group: ApplicationConfig.kube_as_group
      # Для примера
      # logger: Rhelm::Client::SimpleLogger
    }
    if ApplicationConfig.kube_token.present?
      args.merge!(
        kube_token: ApplicationConfig.kube_token,
        kube_apiserver: ApplicationConfig.kube_apiserver,
      )
    elsif ApplicationConfig.kubeconfig.present?
      args.merge! kubeconfig: ApplicationConfig.kubeconfig
    end
    @cli = Rhelm::Client.new(**args)
    @set_options = nil
  end

  def install
    with_values do |values_path|
      cli
        .install(release, ApplicationConfig.chart_dir, wait: ApplicationConfig.helm_wait, timeout: ApplicationConfig.helm_timeout, set: set_options, values: values_path)
        .run &method(:run_block)
    end
  end

  def upgrade
    with_values do |values_path|
      cli
        .upgrade(release, ApplicationConfig.chart_dir, set: set_options, values: values_path)
        .run
    end
  end

  def uninstall
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

  attr_reader :release, :set_args, :values, :set_options

  def logger
    Rails.logger
  end

  def with_values(&block)
    file = Tempfile.new(release + "-values.yaml")
    file.write values.to_yaml
    file.close
    block.call file.path
  ensure
    file&.unlink
  end

  def run_block(lines, status)
    if status == 0
      logger.info("helm install worked great!")
    elsif /timeout/im.match(lines)
      raise MyTimeoutError, "helm install timed out, oh no!"
    else
      # Use the built-in error reporting code to get more details
      report_failure(lines, status)
    end
  end
end
