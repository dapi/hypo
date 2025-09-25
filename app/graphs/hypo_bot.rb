class HyboBot < TelegramBot::Graph
  # Узлы графа - это состояния диалога
  node :start do
    message "Добро пожаловать!"

    # Множественные выходы из узла
    edge :new_user, to: :registration, when: -> { !user_registered? }
    edge :returning, to: :main_menu, when: -> { user_registered? }
  end

  node :registration do
    collect :email, prompt: "Введите email"
    collect :phone, prompt: "Введите телефон"

    edge :success, to: :main_menu do
      validate_and_save_user
    end

    edge :error, to: :registration_error
  end

  node :main_menu do
    menu title: "Выберите действие" do
      option "Заказать", to: :order_flow
      option "История", to: :history
      option "Поддержка", to: :support_flow
      option "Настройки", to: :settings
    end
  end

  # Подграф для сложной логики заказа
  subgraph :order_flow do
    inherit_context true

    node :select_items do
      # Динамическая загрузка из базы
      items = load_available_items
      multi_select items, store_as: :selected_items

      edge :next, to: :delivery_address
    end

    node :delivery_address do
      llm_extract :address_components do
        prompt "Введите адрес доставки"
        schema {
          street: :string,
          house: :string,
          apartment: :string
        }
      end

      edge :confirmed, to: :payment
    end

    node :payment do
      integrate :payment_gateway do
        amount calculate_total(context[:selected_items])
      end

      edge :success, to: :order_confirmed
      edge :failure, to: :payment_error, retry: 3
    end
  end

  # Глобальные перехватчики
  intercept pattern: /отмена|cancel/i do
    transition_to :cancelled
  end

  intercept pattern: /помощь|help/i do
    show_contextual_help
  end
end

