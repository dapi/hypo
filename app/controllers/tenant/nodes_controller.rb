module Tenant
  class NodesController < ApplicationController
    include PaginationSupport
    include RansackSupport

    def new
      node = Node.new title: Faker::App.name
      node.assign_attributes permitted_params
      render locals: { node: node }
    end

    def create
      node = current_account.nodes.create! permitted_params
      redirect_to tenant_node_path(node), notice: "Создан узел #{node.title}"
    rescue ActiveRecord::RecordInvalid => e
      render :new, locals: { node: e.record }
    end

    def show
      render :show, locals: { node: current_account.nodes.find(params[:id]) }
    end

    def destroy
      node=current_account.nodes.find(params[:id])
      node.finish!
      # node.destroy!

      redirect_to tenant_nodes_path, notice: "Узел #{node.title} удален"
    end

    private

    def permitted_params
      return {} unless params.key? :node
      params.require(:node).permit(Node::OPTIONS + [ :title ])
    end
  end
end
