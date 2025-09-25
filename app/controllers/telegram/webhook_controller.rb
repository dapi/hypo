# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    include Telegram::Bot::UpdatesController::MessageContext
    include Telegram::Bot::UpdatesController::CallbackQueryContext
    # include Telegram::Bot::UpdatesController::TypedUpdate
    include Telegram::Session

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

    # Calculates action name and args for payload.
    # Uses `action_for_#{payload_type}` methods.
    # If this method doesn't return anything
    # it uses fallback with action same as payload type.
    # Returns array `[action, args]`.
    def bot_action_for_payload
      if payload_type
        send("action_for_#{payload_type}") || action_for_default_payload
      else
        [:unsupported_payload_type, []]
      end
    end

    def action_for_payload
      [:bot_flow_action, [payload]]
    end

    def bot_flow_action(*args)
      action, args = bot_action_for_payload
      bot_flow.process action, *args
    end

    private

    def bot_flow
      @bot_flow ||= HypoBot.new from_id: from['id'], chat_id: chat['id'], controller: self, session:
    end

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
  end
end
