# frozen_string_literal: true

module Multitenancy
  class Elevator
    Error = Class.new StandardError
    NoSchemaExists = Class.new Error

    def initialize(app)
      @app = app
    end

    def call(env)
      raise 'wtf' if RequestStore.store[:account]

      subdomain = fetch_subdomain env
      return @app.call env if subdomain.nil? || subdomain == 'admin'

      account = find_account subdomain

      # TODO: Return "Not Found?
      return @app.call env if account.nil?

      account.switch { @app.call(env) }
    end

    private

    def fetch_subdomain(env)
      request = Rack::Request.new(env)
      ActionDispatch::Http::URL
        .extract_subdomains(request.host, ActionDispatch::Http::URL.tld_length)
        .first
    end

    def find_account(subdomain)
      account = Account.find_by(subdomain:)
      return if account.nil?
      # TODO cache existen schemas
      raise NoSchemaExists unless Multitenancy.schema_exists? account.tenant_name
      RequestStore.store[:account] = account
    end
  end
end
