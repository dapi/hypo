module Tenant
  class ProjectExtensionsController < ApplicationController
    before_action do
      @back_url = action_name == "index" ? root_path : tenant_project_extensions_path
    end

    def index
      render locals: { project_extensions: current_account.project_extensions.order(:created_at) }
    end

    def new
      project_extension = ProjectExtension.new
      project_extension.set_defaults
      project_extension.assign_attributes permitted_params
      render locals: { project_extension: project_extension }
    end

    def create
      project_extension = current_account.project_extensions.create! permitted_params
      redirect_to tenant_project_extension_path(project_extension), notice: "Создается сервис #{project_extension.name}"
    rescue ActiveRecord::RecordInvalid => e
      render :new, locals: { project_extension: e.record }, status: :unprocessable_entity
    end

    def show
      render :show, locals: { project_extension: current_account.project_extensions.find(params[:id]) }
    end

    def destroy
      project_extension = current_account.project_extensions.find(params[:id])
      project_extension.destroy!
      redirect_back fallback_location: tenant_project_extensions_path, notice: "Сервис #{project_extension.title} удалён"
    end

    private

    def permitted_params
      return {} unless params.key? :project_extension
      params.require(:project_extension).permit(:name, :title, :blockchain_id, :params, :summary, :extra_dataset_paths)
    end
  end
end
