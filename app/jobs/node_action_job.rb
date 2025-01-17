class NodeActionJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1, key: ->(node_id) { node_id }, duration: 5.minutes

  def perform(node_id, action)
    node = Node.find node_id
    send action node
  rescue => err
    node&.fail! err
  end

  private

  def finish
    node.finish!
    node.orchestrator.install
    node.finished!
  end

  def start
    node.start!
    node.orchestrator.install
    node.started!
  end
end
