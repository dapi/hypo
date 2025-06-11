module Tenant
  class NodesController < ApplicationController
    include PaginationSupport
    include RansackSupport

    before_action do
      @back_url = action_name == "index" ? root_path : tenant_nodes_path
    end

    def index
      render locals: { nodes: current_account.nodes.alive.order(:created_at) }
    end

    def update_latest_block
      node = current_account.nodes.find(params[:id])
      node.post! '{"method":"anvil_reset","params":[{"forking": {"blockNumber":"latest"}}],"id":1,"jsonrpc":"2.0"}'

      redirect_to tenant_node_path(node), notice: "Обновляю последний блок"
    end

    def restart
      node = current_account.nodes.find(params[:id])
      StartNodeJob.perform_later node, true

      redirect_to tenant_node_path(node), notice: "Перезапукаю узел"
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

      node.with_lock do
        if node.initiated? || node.failed_to_start? || node.starting?
          node.destroy!
          redirect_back fallback_location: tenant_nodes_path, notice: "Узел #{node.title} удалён"
          return
        end
      end

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
