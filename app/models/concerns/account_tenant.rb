# frozen_string_literal: true

module AccountTenant
  extend ActiveSupport::Concern
  TENANT_PREFIX = "tenant_"
  TENANT_KEY_SYMBOLS = "1234567890#{('a'..'z').to_a.join}".freeze

  included do
    before_create { self.tenant_key ||= generate_tenant_key }
    after_destroy { Multitenancy.drop tenant_name }

    def self.tenant_names
      pluck(:tenant_key).map { |tenant_key| TENANT_PREFIX + tenant_key }
    end
  end

  def switch(&)
    Multitenancy.switch(tenant_name, &)
  end

  def tenant_name
    TENANT_PREFIX + tenant_key
  end

  private

  def generate_tenant_key
    Nanoid.generate size: 10, alphabet: TENANT_KEY_SYMBOLS
  end
end
