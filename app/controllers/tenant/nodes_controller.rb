module Tenant
  class NodesController < ApplicationController
    include PaginationSupport
    include RansackSupport

    def index
      render locals: { nodes: current_account.nodes.alive.order(:created_at) }
    end

    def new
      node = Node.new
      node.set_defaults
      node.assign_attributes permitted_params
      render locals: { node: node }
    end

    def create
      node = current_account.nodes.create! permitted_params
      StartNodeJob.perform_later node
      redirect_to tenant_node_path(node), notice: "Создается узел #{node.title}"
    rescue ActiveRecord::RecordInvalid => e
      render :new, locals: { node: e.record }, status: :unprocessable_entity
    end

    def show
      render :show, locals: { node: current_account.nodes.find(params[:id]) }
    end

    def destroy
      node = current_account.nodes.find(params[:id])

      FinishNodeJob.perform_later node
      redirect_back fallback_location: tenant_nodes_path, notice: "Узел #{node.title} удаляется"
    end

    private

    def permitted_params
      return {} unless params.key? :node
      params.require(:node).permit(Node::OPTIONS + [ :title ])
    end
  end
end
