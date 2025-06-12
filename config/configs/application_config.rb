# frozen_string_literal: true

# Base class for application config classes
class ApplicationConfig < Anyway::Config
  TELEGRAM_LINK_PREFIX = "https://t.me/"
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
    kube_create_namespace: false, # Для разработки полезно иметь true
    cluster_issuer: "letsencrypt-http",
    telegram_auth_expiration: 120, # В Секундах
    tls_secret_name: "vilna-nodes-tls",
    node_host: "node.localhost",
    chart_dir: "./charts/anvil",
    bot_token: "",
    bot_username: "",
    reserved_subdomains: "www,node,vilna",
    home_subdomain: "app",
    redis_cache_store_url: "redis://localhost:6379/2",
    helm_timeout: "10s",
    nodex_template_url: "http://nodex-${BLOCKCHAIN_KEY}.nodex.svc.cluster.local:8080",
    default_mnemonic: "cash boat total sign print jaguar soup dutch gate universe expect tooth",
    anvil_arguments: "--auto-impersonate --no-storage-caching --no-rate-limit --disable-default-create2-deployer --no-mining --transaction-block-keeper 64 --prune-history 50"
  )

  coerce_types(
    telegram_auth_expiration: :integer,
    kube_create_namespace: :boolean,
  )

  def home_url
    if home_subdomain.present?
      protocol + "://" + home_subdomain + "." + host
    else
      protocol + "://" + host
    end
  end

  def anvil_arguments
    super.split
  end

  def bot_url
    TELEGRAM_LINK_PREFIX + bot_username
  end

  def bot_id
    bot_token.split(":").first
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
