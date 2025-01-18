class DashboardController < ApplicationController
  def index
    if logged_in?
      redirect_to tenant_root_url(subdomain: current_user.default_account.subdomain), allow_other_host: true
    else
      redirect_to new_session_url
    end
  end
end
