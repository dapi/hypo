module Telegram::Commands::Start
  extend ActiveSupport::Concern
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
end
