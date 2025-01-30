# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  env_prefix :vilna
  attr_config(
    app_title: "Vilna",
    host: "localhost",
    protocol: "https",
    kubeconfig: nil, # ".kube/config",
    kube_token: nil,
    kube_token_file: nil, # "/var/run/secrets/kubernetes.io/serviceaccount/token",
    kube_ca_file: nil, # "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt",
    kube_apiserver: nil, # "https://kubernetes.default.svc",
    kube_namespace: "vilna-nodes-" + Rails.env,
    kube_as_group: nil,
    kube_as_user: nil,
    telegram_auth_expiration: 120, # В Секундах
    tls_secret_name: "anvil-node-blockberry-cc-tls",
    node_host: "node.localhost",
    chart_dir: "./charts/anvil",
    bot_token: "",
    bot_username: "",
    reserved_subdomains: "www,node,vilna",
    home_subdomain: "app",

    helm_wait: true,
    helm_timeout: 600,
  )

  coerce_types helm_wait: :boolean,
    helm_timeout: :integer,
    telegram_auth_expiration: :integer

  def home_url
    if home_subdomain.present?
      protocol + "://" + home_subdomain + "." + host
    else
      protocol + "://" + host
    end
  end

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
