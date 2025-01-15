# frozen_string_literal: true

class AccountConstraint
  def self.matches?(_request)
    RequestStore.store[:account].present?
  end
end
