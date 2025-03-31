module SessionEmail
  private

  def session_email=(email)
    session[:last_used_email] = email
  end

  def session_email
    session[:last_used_email]
  end
end
