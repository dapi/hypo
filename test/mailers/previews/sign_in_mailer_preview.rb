# Preview all emails at http://localhost:3000/rails/mailers/sign_in_mailer
class SignInMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/sign_in_mailer/send_code
  def send_code
    SignInMailer.send_code
  end
end
