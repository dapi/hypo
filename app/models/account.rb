class Account < ApplicationRecord
  include AccountSubdomain

  has_many :nodes
  belongs_to :owner, class_name: "User"
end
