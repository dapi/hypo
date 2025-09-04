module Telegram::Commands::Start
  extend ActiveSupport::Concern
  def start!(word = nil, *other_words)
    if current_user.present?
      if current_user.read_guide_at.present?
        respond_with :message, text: "С возвращением, #{nickname} ;)"

        # TODO Что дальше? Вводим новую гипотезу или продолжаем диалог? Или спросить что делать дальше?
        start_new_hypo
      else
        welcome_read_guide
      end
    else
      start_new_user
    end
  end

  def restart!(*)
    current_user.update! read_guide_at: nil
    start!
  end

  def read_guide_callback_query(*args)
    current_user.touch :read_guide_at
    reply_with :message, text: "О какая ты умничка! Зачёт ;)"
    start_new_hypo
  end

  private

  def start_new_hypo
    save_context :new_hypo
    respond_with :message, text: multiline(
      "А теперь напиши своими словами основную гипотезу которую ты хочешь проверить.",
      "",
      "Например: «Мы предполагаем, что новые пользователи мобильного приложения увеличат retention на 7-й день на 20% при добавлении интерактивного онбординга с подсказками по основным функциям, потому что это снизит когнитивную нагрузку и ускорит получение первой ценности»"
    )
  end

  def welcome_message
    multiline(
    "Я помогаю проверять гипотезы нового бизнеса.",
    'Делаю это по технологии описанной в этом руководстве: <a href="https://hadi-lab.ru/guide">HADI Lab</a>.',
    "Ознакомься, пожалуйста, с руководством, прежде чем продолжить далее."
    )
  end

  def welcome_read_guide
    session[:start_read_guide] = Time.zone.now
    respond_with :message,
      text: welcome_message,
      reply_markup: {
        resize_keyboard: true,
        inline_keyboard: [ [ { text: "Ознакомился, давай дальше", callback_data: "read_guide:1" } ] ],
        one_time_keyboard: true
      },
      parse_mode: :html
  end

  def start_new_user
    data = { tid: telegram_user.id, t: Time.zone.now.to_i }
    token = verifier.generate data, purpose: :login
    respond_with :message,
      text: "#{nickname}, поздравляю! Вы авторизованы!\nВернитесь на сайт чтобы закончить регистрацию: #{Rails.application.routes.url_helpers.telegram_confirm_url(token:)}"
  end
end
