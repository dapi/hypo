class StartNodeJob < ApplicationJob
  queue_as :default
  limits_concurrency to: 1,
    key: ->(node, _restart = false) { node.id },
    duration: 5.minutes,
    group: :nodes

  def perform(node, restart = false)
    node.update_column :last_node_job_error_message, nil
    if node.failed_to_start? || (node.processing? && restart)
      node.restart!
      node.orchestrator.uninstall if node.orchestrator.exists?
    else
      node.start!
    end

    node.orchestrator.install
    node.started!
  rescue => err
    Rails.logger.error "NodeActionJob[#{node}] catch error #{err}"
    node&.update_column :last_node_job_error_message, err.message
    node&.failed! unless node.failed_to_start?
    raise err
  end
end
