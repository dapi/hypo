require "account_constraint"
require "admin_constraint"

Rails.application.routes.draw do
  get "/", to: redirect(ApplicationConfig.home_url), constraints: { subdomain: "www" }

  constraints subdomain: "" do
    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check
  end


  constraints subdomain: ApplicationConfig.home_subdomain do
    root "dashboard#index"

    resource :session

    # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
    # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
    # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

    get "telegram/auth_callback", to: "telegram_auth_callback#create"
    get "telegram/confirm", to: "telegram_auth_callback#confirm"
    telegram_webhook Telegram::WebhookController

    resource :profile, only: %i[show update], controller: "profile"
    resources :accounts, only: %i[index show]
  end

  # TODO: constraint superadmin only
  constraints subdomain: "admin" do
    constraints AdminConstraint do
      mount SolidQueueDashboard::Engine, at: "/solid-queue"
      scope module: :admin, as: :admin do
        resources :users
        resources :telegram_users
        resources :accounts
        resources :nodes
        resources :memberships
        root to: "accounts#index"
      end
    end
  end

  scope module: :tenant, as: :tenant, constraints: AccountConstraint do
    root to: redirect("/nodes")
    resources :nodes
  end
end
