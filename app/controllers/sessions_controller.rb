class SessionsController < ApplicationController
  include SessionEmail
  # There are no needs
  # allow_unauthenticated_access only: %i[ new create ]

  # For destroy from different domain
  skip_before_action :verify_authenticity_token

  layout "signin"

  # rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    render locals: {
      user_session: EmailForm.new(email: session_email)
    }
  end

  def create
  end

  def destroy
    logout
    redirect_to root_url(format: :html), status: :see_other, notice: t("flash.buy")
  end
end
