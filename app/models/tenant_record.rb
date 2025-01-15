# frozen_string_literal: true

class TenantRecord < ApplicationRecord
  self.abstract_class = true
  # connects_to database: { writing: :tenant, reading: :tenant }

  before_save do
    raise 'Must not be public schema' if Multitenancy.default_schema? && !Rails.env.test?
  end
end
