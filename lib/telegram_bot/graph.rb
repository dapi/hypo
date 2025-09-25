require 'telegram_bot/node'
module TelegramBot
  class Graph
    include ActiveModel::Model

    # attr_accessor :current_state, :context, :user_id, :chat_id, :controller

    class << self
      def start! &block
        command 'start!', &block
      end

      def command(name, &block)
        add_step name, Command.new(name, &block)
      end

      def confirm(name, text:, on_confirm:, &block)
        add_step name, Confirmation.new(name, text:, on_confirm:, &block)
      end

      def ask(name, text:, on_answer:, &block )
        add_step name, Ask.new(name, text:, on_answer:, &block)
      end

      def wait(name, &block )
        add_step name, Wait.new(name, &block)
      end

      private

      def add_command name, &block
      end

      def add_step(name, step)
        @steps ||= {}
        name = name.to_s
        raise "Step with name #{name} is already exists" if @steps.key? name
        @steps[name] = step
      end
    end

    def initialize(user_id:, chat_id: nil, controller: nil)
      @user_id = user_id
      @chat_id = chat_id
      @controller = controller
      @steps = {}
    end

    private

    attr_reader :controller

  end
end
