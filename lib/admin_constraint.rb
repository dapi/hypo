# frozen_string_literal: true

class AdminConstraint
  def self.matches?(request)
    User.find_by_id(request.session[:user_id]).try &:superadmin?
  end
end
