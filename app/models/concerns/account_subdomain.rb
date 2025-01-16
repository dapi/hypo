# frozen_string_literal: true

module AccountSubdomain
  extend ActiveSupport::Concern
  SUBDOMAIN_LENGTH = 8
  SUBDOMAIN_SYMBOLS = "1234567890#{('a'..'z').to_a.join}".freeze
  SUBDOMAIN_PREFIX_SYMBOLS = ("a".."z").to_a.freeze

  included do
    before_create { self.subdomain ||= generate_subdomain }
  end

  private

  def generate_subdomain
    SUBDOMAIN_PREFIX_SYMBOLS.sample +
      Nanoid.generate(size: SUBDOMAIN_LENGTH-1, alphabet: SUBDOMAIN_SYMBOLS)
  end
end
