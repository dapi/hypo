module SessionEmail
  extend ActiveSupport::Concern
  included do
    helper_method :session_email_code
  end

  private

  def session_code_sent_at
    session[:code_sent_at]
  end

  def session_code_sent_at=(at)
    session[:code_sent_at] = at
  end

  def session_email_code=(code)
    session[:email_code] = code
  end

  def session_email_code
    session[:email_code]
  end

  def session_email=(email)
    session[:last_used_email] = email
  end

  def session_email
    session[:last_used_email]
  end
end
