# frozen_string_literal: true

module Multitenancy
  class Elevator
    def initialize(app)
      @app = app
    end

    def call(env)
      raise "wtf" if RequestStore.store[:account]

      subdomain = fetch_subdomain env
      return @app.call env if subdomain.nil? || subdomain == "admin"

      RequestStore.store[:account] = Account.find_by subdomain: subdomain

      @app.call(env)
    end

    private

    def fetch_subdomain(env)
      request = Rack::Request.new(env)
      ActionDispatch::Http::URL
        .extract_subdomains(request.host, ActionDispatch::Http::URL.tld_length)
        .first
    end
  end
end
