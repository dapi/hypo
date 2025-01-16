# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class TelegramAuthCallbackController < ApplicationController
  def self.sign_params(data_params)
    data_check_string = data_params.sort.map { |k, v| [k, v].join('=') }.join("\n")
    secret_key = OpenSSL::Digest::SHA256.new(ApplicationConfig.bot_token).digest
    OpenSSL::HMAC.hexdigest('sha256', secret_key, data_check_string)
  end

  EXPIRED = 5

  before_action :authorize!

  def create
    login data_params

    if current_user.default_account.present?
      redirect_back_or_to private_root_url(subdomain: current_user.default_account.subdomain),
                          notice: t('flash.hi', username: current_user)
    else
      # TODO: На страницу создания аккаунта через тариф
      redirect_back_or_to root_url, notice: t('flash.hi', username: current_user)
    end
  end

  private

  def data_params
    @data_params ||= params
                     .permit(:id, :first_name, :last_name, :username, :photo_url, :auth_date)
                     .to_h
  end

  def authorize!
    return if signed? && fresh?

    raise HumanizedError, 'Unauthorized telegram callback'
  end

  def signed?
    self.class.sign_params(data_params) == params[:hash].to_s
  end

  def fresh?
    Time.zone.at(params.fetch(:auth_date).to_i) >= EXPIRED.minutes.ago
  end
end
