class Account < ApplicationRecord
  include AccountSubdomain

  belongs_to :owner, class_name: "User"
end
