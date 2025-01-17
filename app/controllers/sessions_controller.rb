class SessionsController < ApplicationController
  # There are no needs
  # allow_unauthenticated_access only: %i[ new create ]

  layout "simple"

  # rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def destroy
    logout
    redirect_to root_url(format: :html), status: :see_other, notice: t("flash.buy")
  end
end
