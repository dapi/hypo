# Декларативный стиль с состояниями


```ruby
class OrderBot < TelegramBot::Flow
  # Конфигурация LLM провайдера
  llm_provider :openai, model: 'gpt-4', temperature: 0.7
  
  # Точка входа
  entry_point :greeting
  
  # Определение состояний диалога
  state :greeting do
    message "Привет! Я помогу оформить заказ. Как вас зовут?"
    
    on_response do |response|
      store :user_name, response.text
      transition_to :select_product
    end
  end
  
  state :select_product do
    message { "Отлично, #{context[:user_name]}! Что вы хотите заказать?" }
    
    # Можно добавить клавиатуру
    keyboard [
      ["Пицца", "Суши"],
      ["Бургеры", "Салаты"]
    ]
    
    on_response do |response|
      store :product, response.text
      
      # Условный переход
      if %w[Пицца Суши Бургеры Салаты].include?(response.text)
        transition_to :confirm_order
      else
        retry_with "Пожалуйста, выберите из предложенных вариантов"
      end
    end
  end
  
  state :confirm_order do
    # Использование LLM для генерации ответа
    llm_prompt do
      system "Ты вежливый ассистент ресторана"
      user "Подтверди заказ: #{context[:product]} для #{context[:user_name]}"
    end
    
    on_response pattern: /да|подтверждаю/i do
      transition_to :completed
    end
    
    on_response pattern: /нет|отмена/i do
      transition_to :cancelled
    end
    
    fallback { retry_with "Подтвердите заказ: да или нет?" }
  end
  
  state :completed, terminal: true do
    message "Спасибо за заказ! Ожидайте доставку."
    
    after_message do
      notify_kitchen(context)
      log_order(context)
    end
  end
  
  state :cancelled, terminal: true do
    message "Заказ отменен. До свидания!"
  end
  
  # Глобальные обработчики
  on_command "/start" do
    reset_context
    transition_to :greeting
  end
  
  on_command "/help" do
    send_message "Доступные команды: /start - начать заново"
  end
  
  # Middleware для логирования
  before_transition do |from, to|
    log.info "Transition: #{from} -> #{to}"
  end
end
```
