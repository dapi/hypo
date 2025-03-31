class EmailCodeController < ApplicationController
  include SessionEmail

  layout "signin"

  rate_limit to: 3, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  # Отправляет код
  def create
    email_form = EmailForm.new params.require(:email_form).permit(:email)
    code = Nanoid.generate(size: 6, alphabet: "0123456789")

    session[:email_code] = code
    self.session_email= email_form.email

    SignInMailer.with(code:, email: email_form.email).send_code.deliver_now # TODO настроить очередь
    flash[:notice] = "Код для входя отправлен на email #{email_form.email}"
    render "sessions/new", locals: {
      user_session: UserSession.new(email: email_form.email),
      code_sent_at: Time.zone.now
    }, status: :unprocessable_entity
  end
end
