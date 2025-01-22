# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class TelegramAuthCallbackController < ApplicationController
  def self.sign_params(data_params)
    data_check_string = data_params.sort.map { |k, v| [ k, v ].join("=") }.join("\n")
    secret_key = OpenSSL::Digest::SHA256.new(ApplicationConfig.bot_token).digest
    OpenSSL::HMAC.hexdigest("sha256", secret_key, data_check_string)
  end

  before_action :authorize!

  def create
    login data_params
    if current_user.default_account.present?
      url = tenant_root_url(subdomain: current_user.default_account.subdomain)
      redirect_back_or_to url, allow_other_host: true, notice: t("flash.hi", username: current_user)
    else
      # TODO: На страницу создания аккаунта через тариф
      redirect_back_or_to root_url, notice: t("flash.hi", username: current_user)
    end
  end

  private

  def data_params
    @data_params ||= params
                     .permit(:id, :first_name, :last_name, :username, :photo_url, :auth_date)
                     .to_h
  end

  def authorize!
    unless signed?
      Rails.logger.error "Not signed telegram callback #{data_params}, #{self.class.sign_params(data_params)}, #{params[:hash]}"
      raise HumanizedError, "Unauthorized telegram callback"
    end

    unless fresh?
      Rails.logger.error "Expired telegram callback #{auth_date} must be larget then #{expiration_ago}"
      raise HumanizedError, "Expired telegram callback"
    end
  end

  def signed?
    self.class.sign_params(data_params) == params[:hash].to_s
  end

  def auth_date
    Time.at(params.fetch(:auth_date).to_i)
  end

  def fresh?
    auth_date >= expiration_ago
  end

  def expiration_ago
    @expiration_ago ||= Integer(ApplicationConfig.telegram_auth_expiration).minutes.ago
  end
end
