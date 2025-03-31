class SignInMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sign_in_mailer.send_code.subject
  #
  def send_code
    @code = params[:code]
    mail to: params[:email]
  end
end
