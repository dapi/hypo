class NodeChannel < ApplicationCable::Channel
  def subscribed
    node = current_user.nodes.find params[:id]
    stream_from "node:" + node.to_param
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
