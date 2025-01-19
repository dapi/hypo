class NodeActionJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1, key: ->(node, _action) { node.id }, duration: 5.minutes

  def perform(node, action)
    send action, node
  rescue => err
    Rails.logger.error "NodeActionJob[#{node}] catch error #{err}"
    node&.failed!
    raise err
  end

  private

  def finish(node)
    node.finish!
    node.orchestrator.uninstall
    node.finished!
    node.destroy!
  end

  def start(node)
    node.start!
    node.orchestrator.install
    node.started!
  end
end
