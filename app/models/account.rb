class Account < ApplicationRecord
  include AccountSubdomain

  has_many :nodes
  has_many :memberships
  belongs_to :owner, class_name: "User"

  def title
    subdomain
  end
end
