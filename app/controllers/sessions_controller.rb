class SessionsController < ApplicationController
  include SessionEmail
  # There are no needs
  # allow_unauthenticated_access only: %i[ new create ]

  # For destroy from different domain
  skip_before_action :verify_authenticity_token

  layout "signin"

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." } if Rails.env.production?

  def new
    @back_url = :hide
    render locals: {
      user_session: EmailForm.new(email: session_email)
    }
  end

  def show
    redirect_to new_session_url
  end

  def create
    user_session = UserSession.new params.require(:user_session).permit(:email, :code)
    if user_session.code == session_email_code && user_session.email = session_email
      login user_session
      Account.create!(owner: current_user) unless current_user.default_account.present?
      redirect_after_login
    else
      flash.now[:alert] = "Неверный код"
      user_session.errors.add :code, "Неверный код"
      user_session.code = ""
      render "user_session", locals: {
        user_session: user_session
      }, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_url(format: :html), status: :see_other, notice: t("flash.buy")
  end
end
