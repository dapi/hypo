# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    include Telegram::Bot::UpdatesController::MessageContext
    include Telegram::Bot::UpdatesController::CallbackQueryContext
    include Telegram::Bot::UpdatesController::TypedUpdate
    include Telegram::Bot::UpdatesController::Session

    include Telegram::Verifier
    include RescueErrors
    include Commands::Start

    def new_hypo(*)
      message =  payload.fetch('text')
      reply_with :message, text: 'Прекрасная гипотеза, сейчас мы ее проанализируем, оценим и раскроем. Минуточку..'
      # TODO Ask agent
    end

    def callback_query(key)
      Rails.logger.warn "Выбор без контекста, странно: #{args}"
      Bugsnag.notify "Выбор без контекста, странно" do |b|
        b.metadata = { args: }
      end
      # edit_message :text, text: 'Ой, что-то мы потерялись в диалоге.. сообщили разработчикам. Ждите или не ждите )'
      reply_with :message, text: "Ой, что-то мы потерялись в диалоге.. сообщили разработчикам. Ждите или не ждите ;) нам не все равно, но мы медленные."
    end

    private

    def current_user
      telegram_user.user
    end

    def multiline(*args)
      args.flatten.map(&:to_s).join("\n")
    end

    def current_bot_id
      bot.token.split(":").first
    end

    def nickname
      telegram_user.nickname
    end

    def telegram_user
      @telegram_user ||= TelegramUser
        .create_with(chat.slice(*%w[first_name last_name username]))
        .create_or_find_by! id: chat.fetch("id")
    end


    # In this case session will persist for user only in specific chat.
    # Same user in other chat will have different session.
    def session_key
      "#{bot.username}:#{chat['id']}:#{from['id']}" if chat && from
    end
  end
end
