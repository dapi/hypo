class HypoBot << TelegramBot::Graph
  start! do # Такая node
    message "Добро пожаловать!"

    # Множественные выходы из узла
    goto :read_guide, when: -> { !read_guide? }
    goto :new_project, when: -> { !current_project && read_guide? }
    goto :new_hypo, when: -> { current_project && read_guide? }
  end

  restart! do
    reset_read_guide!
    start!
  end

  confirm :read_guide, text: 'Прочтите доку', on_confirm: -> { read_guide! }  do # TODO Может быть назвать этот узел confirm?
    reply_with :message, text: 'Уй ты умничка! Продолжаем..'
    goto :new_project
  end

  ask :new_project, 'Напиши о чем твой проект? Кто потенциальный клиент?', on_answer: -> {  |message| create_project message } do
    reply_with :message, text: 'Отличный проект! Так и запишем.'
    goto :new_hypo
  end

  ask :new_hypo, 'А теперь напиши свою гипотезу и я помогу тебе с её сильной формулировкой', on_answer: -> { |message| validate_with_llm mesage } do
    gogo :hypo_answer
  end

  wait :hypo_answer do
    # TODO Скармливаем гипотезу LLM-ке
    reply_with :message, text: 'Работаем над гипотезой, подождите..'
  end

  private

  def validate_with_llm
  end

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
