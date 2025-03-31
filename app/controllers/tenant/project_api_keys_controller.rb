module Tenant
  class ProjectApiKeysController < ApplicationController
    protect_from_forgery except: :create

    before_action do
      @back_url = action_name == "index" ? root_path : tenant_project_api_keys_path
    end

    def index
      render locals: { project_api_keys: current_account.project_api_keys.order(:created_at) }
    end

    def create
      project_api_key = current_account.project_api_keys.create! creator: current_user
      redirect_to tenant_project_api_keys_path, notice: "Создан ключ #{project_api_key.access_key}"
    rescue ActiveRecord::RecordInvalid => e
      Bugsnag.notify e
      render :new, locals: { project_api_key: e.record }, status: :unprocessable_entity
    end

    def destroy
      project_api_key = current_account.project_api_keys.find(params[:id])
      project_api_key.destroy!
      redirect_back fallback_location: tenant_project_api_keys_path, notice: "Ключ #{project_api_key.access_key} удалён"
    end
  end
end
