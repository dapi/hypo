class FinishNodeJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1,
    key: ->(node, _action) { node.id },
    duration: 5.minutes,
    group: :nodes

  def perform(*args)
    node.finish!
    node.with_lock do
      node.finishing!
      node.orchestrator.uninstall
      node.finished!
      node.destroy!
    end
  rescue => err
    Rails.logger.error "NodeActionJob[#{node}] catch error #{err}"
    node&.failed!
    raise err
  end
end
