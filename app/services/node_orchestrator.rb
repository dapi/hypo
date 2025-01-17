require "rhelm/client"
require "tempfile"

class NodeOrchestrator
  RELEASE_PREFIX = "anvil-"

  attr_reader :cli

  def initialize(path:, node_id:, account_id:, values: {})
    @release = RELEASE_PREFIX + node_id
    @values = values.merge(
      path: path,
      host: ApplicationConfig.node_host,
      extraLabels: {
        'vilna.blockberry.com/nodeId' => node_id,
        'vilna.blockberry.com/accountId' => account_id,
        'vilna.blockberry.com/version' => AppVersion.to_s,
      }
    ).deep_stringify_keys
    @cli = Rhelm::Client.new(
      kubeconfig: ApplicationConfig.kubeconfig,
      namespace: ApplicationConfig.namespace,
      # program: '/path/to/a/specific/helm/binary'
      # logger: Rhelm::Client::SimpleLogger
    )
    @set_options = nil
  end

  def install
    with_values do |values_path|
      cli
        .install(release, ApplicationConfig.chart_dir, create_namespace: true, set: set_options, values: values_path)
        .run &method(:run_block)
    end
  end

  def upgrade
    with_values do |values_path|
      cli
        .upgrade(release, ApplicationConfig.chart_dir, create_namespace: true, set: set_options, values: values_path)
        .run
    end
  end

  def uninstall
    cli.uninstall(release).run
  end

  def status
    cli.status(release).run
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
