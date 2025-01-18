module NodesHelper
  NODE_STATE_CLASSES = {
    "initiated" => "badge text-bg-warning",
    "starting" => "badge text-bg-warning",
    "processing" => "badge text-bg-success",
    "failed_to_start" => "badge text-bg-danger",
    "failed_to_finish" => "badge text-bg-danger",
    "finishing" => "badge text-bg-secondary",
    "finished" => "badge text-bg-secondary"
  }.freeze

  def node_state(state)
    state = state.state if state.is_a? Node
    content_tag :span, state, class: NODE_STATE_CLASSES.fetch(state)
  end
end
