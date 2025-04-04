class StartNodeJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1,
    key: ->(node) { node.id },
    duration: 5.minutes,
    group: :nodes

  def perform(node)
    node.update_column :last_node_job_error_message, nil
    node.start!
    node.with_lock do
      node.starting!
      node.orchestrator.install
      node.started!
    end
  rescue => err
    Rails.logger.error "NodeActionJob[#{node}] catch error #{err}"
    node&.update_column :last_node_job_error_message, err.message
    node&.failed!
    raise err
  end
end
