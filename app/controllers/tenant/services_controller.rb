module Tenant
  class ServicesController < ApplicationController
    before_action do
      @back_url = action_name == "index" ? root_path : tenant_services_path
    end

    def index
      render locals: { services: current_account.services.order(:created_at) }
    end

    def new
      service = Service.new
      service.set_defaults
      service.assign_attributes permitted_params
      render locals: { service: service }
    end

    def edit
      service = current_account.services.find params[:id]
      render locals: { service: }
    end

    def update
      service = current_account.services.find params[:id]
      service.update! permitted_params
      redirect_to tenant_service_path(service), notice: "Изменилось расширение #{service.name}"
    rescue ActiveRecord::RecordInvalid => e
      render :edit, locals: { service: e.record }, status: :unprocessable_entity
    end

    def create
      service = current_account.services.create! permitted_params
      redirect_to tenant_service_path(service), notice: "Создается сервис #{service.name}"
    rescue ActiveRecord::RecordInvalid => e
      render :new, locals: { service: e.record }, status: :unprocessable_entity
    end

    def show
      render :show, locals: { service: current_account.services.find(params[:id]) }
    end

    def destroy
      service = current_account.services.find(params[:id])
      service.destroy!
      redirect_back fallback_location: tenant_services_path, notice: "Сервис #{service.name} удалён"
    end

    private

    def permitted_params
      return {} unless params.key? :service
      params.require(:service).permit(:name, :blockchain_id, :summary, :extra_dataset_paths, :extra_dataset_paths_list)
    end
  end
end
