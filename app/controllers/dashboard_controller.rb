class DashboardController < ApplicationController
  def index
    if logged_in?
      Account.create_with(subdomain: AccountSubdomain.generate_subdomain).create!(owner: current_user) unless current_user.default_account.present?
      redirect_to tenant_root_url(subdomain: current_user.default_account.subdomain), allow_other_host: true
    else
      redirect_to new_session_url
    end
  end

  def version
    render json: { "version": AppVersion.to_s, "deployment_info": "unknown", "name": "hypo" }
  end

  def not_found
    render status: 404, layout: 'simple'
  end
end
