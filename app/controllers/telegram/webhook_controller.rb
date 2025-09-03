# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Telegram
  # Контроллер бота.
  #
  class WebhookController < Bot::UpdatesController
    # include UpdateProjectMembership
    # include Commands::Who
    # include Actions::Message
    # include Actions::MyChatMember
    include RescueErrors
    include Commands::Start

    use_session!

    private

    def current_bot_id
      bot.token.split(":").first
    end

    def telegram_user
      @telegram_user ||= TelegramUser
        .create_with(chat.slice(*%w[first_name last_name username]))
        .create_or_find_by! id: chat.fetch("id")
    end
  end
end
