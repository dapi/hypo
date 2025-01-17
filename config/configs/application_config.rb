# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  env_prefix :vilna
  attr_config(
    app_title: "Vilna",
    host: "localhost",
    protocol: "https",
    kubeconfig: ".kube/config",
    namespace: "anvil-" + Rails.env,
    nodes_domain: ".anvil-nodes.blockberry.cc",
    chart_dir: "./charts/anvil",
    # sidekiq_redis_url: 'redis://localhost:6379/0',
    bot_token: "",
    bot_username: "",
  )

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
