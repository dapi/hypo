# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  TELEGRAM_LINK_PREFIX = "https://t.me/"
  env_prefix :hypo
  attr_config(
    app_title: "Hypo",
    host: "localhost",
    protocol: "http",
    port: "3000",
    llm_provider: "deepseek",
    # config.default_model = "gpt-4.1-nano"
    # config.default_model = "deepseek-reasoner"
    llm_default_model: "deepseek-chat",
    telegram_auth_expiration: 120, # В Секундах
    bot_token: "",
    bot_username: "",
    reserved_subdomains: "www,app",
    deepseek_api_key: "",
    home_subdomain: "app",
    redis_cache_store_url: "redis://localhost:6379/2",
  )

  coerce_types(
    telegram_auth_expiration: :integer,
  )

  def home_url
    if home_subdomain.present?
      "#{protocol}://#{home_subdomain}.#{host}:#{port_suffix}"
    else
      "#{protocol}://#{host}#{port_suffix}"
    end
  end

  def port_suffix
    return if port.blank?
    return if port.to_s == "80" && protocol == "http"
    return if port.to_s == "443" && protocol == "https"

    ":#{port}"
  end

  def default_url_options
    options = { host:, protocol: }
    options.merge! port: port unless (port.to_s == "80" && protocol == "http") || (port.to_s == "443" && protocol == "https")
    options
  end

  def tld_length
    host.split(".").count - 1
  end

  def home_url
    if home_subdomain.present?
      protocol + "://" + home_subdomain + "." + host
    else
      protocol + "://" + host
    end
  end

  def bot_url
    TELEGRAM_LINK_PREFIX + bot_username
  end

  def bot_id
    bot_token.split(":").first
  end

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explicitly calling `instance`)
    delegate_missing_to :instance

    private

    # Returns a singleton config instance
    def instance
      @instance ||= new
    end
  end
end
