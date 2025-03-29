module Tenant
  class ServicesController < ApplicationController
    def index
      render locals: { services: current_account.services.order(:created_at) }
    end

    def new
      service = Service.new
      service.set_defaults
      service.assign_attributes permitted_params
      render locals: { service: service }
    end

    def create
      service = current_account.services.create! permitted_params
      redirect_to tenant_service_path(service), notice: "Создается сервис #{service.title}"
    rescue ActiveRecord::RecordInvalid => e
      render :new, locals: { service: e.record }, status: :unprocessable_entity
    end

    def show
      render :show, locals: { service: current_account.services.find(params[:id]) }
    end

    def destroy
      service = current_account.services.find(params[:id])

      service.with_lock do
        if service.initiated? || service.failed_to_start? || service.to_start?
          service.destroy!
          redirect_back fallback_location: tenant_services_path, notice: "Сервис #{service.title} удалён"
          return
        end
      end

      FinishserviceJob.perform_later service
      redirect_back fallback_location: tenant_services_path, notice: "Сервис #{service.title} удаляется"
    end

    private

    def permitted_params
      return {} unless params.key? :service
      params.require(:service).permit(:name, :blockchain_id, :extra_dataset_paths)
    end
  end
end
