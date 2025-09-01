# frozen_string_literal: true

module AccountSubdomain
  extend ActiveSupport::Concern
  SUBDOMAIN_LENGTH = 8
  SUBDOMAIN_SYMBOLS = "1234567890#{('a'..'z').to_a.join}".freeze
  SUBDOMAIN_PREFIX_SYMBOLS = ("a".."z").to_a.freeze

  def self.generate_subdomain
    return "demo" if Rails.env.development? && Account.count.zero?
    SUBDOMAIN_PREFIX_SYMBOLS.sample +
      Nanoid.generate(size: SUBDOMAIN_LENGTH-1, alphabet: SUBDOMAIN_SYMBOLS)
  end

  included do
    before_create { self.subdomain ||= AccountSubdomain.generate_subdomain }
  end
end
