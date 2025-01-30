# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    # include UpdateProjectMembership
    # include Commands::Start
    # include Commands::Who
    # include Actions::Message
    # include Actions::MyChatMember
    # include Telegram::RescueErrors

    rescue_from Telegram::Bot::Forbidden, with: :bot_forbidden
    rescue_from Telegram::Bot::Error, with: :bot_error
    use_session!

    def start!(word = nil, *other_words)
      if word.start_with? ApplicationHelper::AUTH_PREFIX
        session_token = word.delete ApplicationHelper::AUTH_PREFIX
        verifier = Rails.application.message_verifier :telegram
        data = { st: session_token, tid: telegram_user.id, t: Time.zone.now.to_i }
        token = verifier.generate(data, purpose: :login)
        respond_with :message, text: "Вы авторизованы! Перейдите на сайт: #{Rails.application.routes.url_helpers.telegram_confirm_url(token:)}"
      else
        respond_with :message, text: "Привет! Чтобы авторизоваться перейдите на сайт: #{Rails.application.routes.url_helpers.new_session_url}"
      end
    end

    # before_action do
    # @telegram_event = TelegramEvent.create! payload: update
    # end

    private

    # Пользователь написал в бота и заблокировал его (наверное добавлен где-то в канале или тп)
    def bot_forbidden(error)
      Bugsnag.notify error
      Rails.logger.error "#{error} #{chat.to_json}"
    end

    # У бота уже нет доступа отвечать в чат
    #
    def bot_error(error)
      Bugsnag.notify error
      Rails.logger.error "#{error} #{chat.to_json}"
    end

    def current_bot_id
      bot.token.split(":").first
    end

    def telegram_user
      @telegram_user ||= TelegramUser
        .create_with(chat.slice(*%w[first_name last_name username]))
        .create_or_find_by! id: chat.fetch("id")
    end

    def notify_bugsnag(message)
      Rails.logger.warn message
      Bugsnag.notify message do |b|
        b.metadata = payload
      end
    end
  end
end
