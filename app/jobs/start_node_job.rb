class StartNodeJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1,
    key: ->(node, _action) { node.id },
    duration: 5.minutes,
    group: :nodes

  def perform(node)
    node.start!
    node.with_lock do
      node.starting!
      node.orchestrator.install
      node.started!
    end
  rescue => err
    Rails.logger.error "NodeActionJob[#{node}] catch error #{err}"
    node&.failed!
    raise err
  end
end
