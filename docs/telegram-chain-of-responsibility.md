# Цепочечный стиль (Chain of Responsibility)

```ruby
class SupportBot < TelegramBot::Chain
  # Настройка LLM
  configure do
    llm :anthropic, model: 'claude-3'
    timeout 30.seconds
    max_retries 3
  end
  
  # Цепочка шагов
  flow do
    step :collect_problem do
      ask "Опишите вашу проблему"
      validate presence: true, min_length: 10
      store_as :problem_description
    end
    
    step :categorize do
      # LLM классифицирует проблему
      llm_classify :problem_description,
                   categories: ['technical', 'billing', 'general'],
                   store_as: :category
    end
    
    step :collect_details do
      # Динамический вопрос на основе категории
      ask do
        case context[:category]
        when 'technical'
          "Какая у вас операционная система?"
        when 'billing'
          "Укажите номер вашего счета"
        else
          "Нужна ли дополнительная информация?"
        end
      end
      store_as :additional_info
    end
    
    step :generate_solution do
      llm_generate do
        template <<~PROMPT
          Пользователь: #{context[:problem_description]}
          Категория: #{context[:category]}
          Дополнительно: #{context[:additional_info]}
          
          Предложи решение проблемы.
        PROMPT
      end
      
      send_response
    end
    
    step :feedback do
      ask "Помог ли вам ответ?",
          options: ["Да", "Нет", "Частично"]
      
      on "Да" do
        finish_with "Рад помочь!"
      end
      
      on "Нет", "Частично" do
        escalate_to_human
      end
    end
  end
  
  # Обработка ошибок
  on_error do |error|
    send_message "Произошла ошибка. Попробуйте позже."
    notify_admin(error)
  end
end
```
