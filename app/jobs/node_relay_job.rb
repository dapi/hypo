# Не используется сейчас
class NodeRelayJob < ApplicationJob
  queue_as :default

  def perform(node, previous_changes = {})
    NodesChannel.broadcast_to(
      node.id,
      node: node.as_json,
      previous_changes:,
      # group_setup_page: ProjectsController.render(partial: 'projects/group/setup', locals: { project: })
    )
  end
end
