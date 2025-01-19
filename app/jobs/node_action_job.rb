class NodeActionJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1, key: ->(node, _action) { node.id }, duration: 5.minutes

  def perform(node, action)
    send action node
  rescue => err
    node&.failed! err
  end

  private

  def finish
    node.finish!
    node.orchestrator.uninstall
    node.finished!
    node.destroy!
  end

  def start
    node.start!
    node.orchestrator.install
    node.started!
  end
end
