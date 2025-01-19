# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  env_prefix :vilna
  attr_config(
    app_title: "Vilna",
    host: "localhost",
    protocol: "https",
    kubeconfig: ".kube/config",
    kube_token: nil,
    kube_token_file: "/var/run/secrets/kubernetes.io/serviceaccount/token",
    kube_ca_file: "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt",
    kube_apiserver: "https://kubernetes.default.svc",
    kube_namespace: "anvil-" + Rails.env,
    kube_as_group: nil,
    kube_as_user: nil,
    tls_secret_name: "anvil-node-blockberry-cc-tls",
    node_host: "anvil-node.blockberry.cc",
    chart_dir: "./charts/anvil",
    # sidekiq_redis_url: 'redis://localhost:6379/0',
    bot_token: "",
    bot_username: "",
  )

  def kube_token
    super || kube_token_from_file
  end

  def kube_token_from_file
    File.read kube_token_file if kube_token_file.present?
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
