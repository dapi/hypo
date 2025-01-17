require "rhelm/client"
require "tempfile"

class NodeOrchestrator
  RELEASE_PREFIX = "anvil-"

  attr_reader :cli

  def initialize(node_key, host)
    @node_key = node_key
    @release = RELEASE_PREFIX + node_key
    @set_args = "host=" + host
    @cli = Rhelm::Client.new(
      kubeconfig: ApplicationConfig.kubeconfig,
      namespace: ApplicationConfig.namespace,
      # program: '/path/to/a/specific/helm/binary'
      # logger: Rhelm::Client::SimpleLogger
    )
  end

  def install(values: {})
    with_values values do |values_path|
      cli
        .install(release, ApplicationConfig.chart_dir, create_namespace: true, set: set_args, values: values_path)
        .run &method(:run_block)
    end
  end

  def upgrade(values: {})
    with_values values do |values_path|
      cli
        .upgrade(release, ApplicationConfig.chart_dir, create_namespace: true, set: set_args, values: values_path)
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

  attr_reader :release, :node_key, :set_args

  def logger
    Rails.logger
  end

  def with_values(values, &block)
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
