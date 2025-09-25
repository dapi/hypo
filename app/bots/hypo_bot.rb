class HypoBot < TelegramBot::Graph
  start! do
    replay_with :message, text: "Добро пожаловать!"
    if read_guide?
      if current_project
        goto :new_hypo
      else
        goto :new_project
      end
    else
      goto :read_guide
    end
  end

  command :restart! do
    reset_read_guide!
    start!
  end

  confirm :read_guide, text: 'Прочтите доку' do
    read_guide!
    reply_with :message, text: 'Уй ты умничка! Продолжаем..'
    goto :new_project
  end

  ask :new_project, text: 'Напиши о чем твой проект? Кто потенциальный клиент?' do |message|
    create_project message
    reply_with :message, text: 'Отличный проект! Так и запишем.'
    goto :new_hypo
  end

  ask :new_hypo, text: 'А теперь напиши свою гипотезу и я помогу тебе с её сильной формулировкой' do |message|
    validate_with_llm mesage
    goto :hypo_answer
  end

  wait :hypo_answer do
    # TODO Скармливаем гипотезу LLM-ке
    reply_with :message, text: 'Работаем над гипотезой, подождите..'
  end

  private

  def reset_read_guide!
    current_user.update! read_guide_at: nil
  end

  def create_project message
    project = current_user.projects.create! about: message
    session[:project] = product
  end

  def current_project
    session[:project]
  end

  def read_guide!
    current_user.touch :read_guide_at
  end

  def read_guide?
    current_user.read_guide_at.present?
  end
end
