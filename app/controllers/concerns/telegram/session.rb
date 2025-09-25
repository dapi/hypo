module Telegram
  module Session
    extend ActiveSupport::Concern

    def process_action(*)
      super
    ensure
      session.commit if @_session
    end

    private

    def session
      @_session ||= TelegramSession.new telegram_user
    end
  end
end
