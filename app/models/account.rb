class Account < ApplicationRecord
  include AccountTenant
  belongs_to :owner, class_name: "User"

  alias_attribute :subdomain, :tenant_key
end
