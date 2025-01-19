module NodesHelper
  NODE_STATE_CLASSES = {
    "initiated"        => "badge text-bg-warning",
    "starting"         => "badge text-bg-warning",
    "to_start"         => "badge text-bg-warning",
    "processing"       => "badge text-bg-success",
    "failed_to_start"  => "badge text-bg-danger",
    "failed_to_finish" => "badge text-bg-danger",
    "finishing"        => "badge text-bg-secondary",
    "to_finish"        => "badge text-bg-secondary",
    "finished"         => "badge text-bg-secondary"
  }.freeze

  NODE_STATE_TITLES = {
    "initiated" => "Starting..",
    "starting" => "Starting..",
    "to_start" => "Starting..",
    "processing" => "Live",
    "failed_to_start" => "Error",
    "failed_to_finish" => "Error",
    "to_finish" => "Stopping..",
    "finishing" => "Stopping..",
    "finished" => "Stopped"
  }

  def node_state(state)
    state = state.state if state.is_a? Node
    title = NODE_STATE_TITLES.fetch(state)
    content_tag :span, title, class: NODE_STATE_CLASSES.fetch(state), title: state
  end
end
