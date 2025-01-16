class Tenant::ApplicationController < ApplicationController
  include Authentication
  layout "tenant"

  helper_method :current_account, :current_membership

  before_action :require_login
  before_action :touch_user_session
  before_action :require_membership

  private

  def require_membership
    return if current_membership.present?

    raise NotAuthorized
  end

  def touch_user_session
    session[:logged_at] = Time.zone.now.to_i
  end

  def current_membership
    (@current_membership ||= current_account.memberships.find_by(user: current_user))&.freeze
  end

  def current_account
    @current_account ||= RequestStore.store[:account].freeze
  end
end
