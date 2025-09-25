require 'telegram_bot/node'
module TelegramBot
  class Graph
    include ActiveModel::Model

    class << self
      def start! &block
        command 'start!', &block
      end

      def command(name, &block)
        add_step name, Command.new(name, &block)
      end

      def confirm(name, text:, &block)
        add_step name, Confirmation.new(name, text:, &block)
      end

      def ask(name, text:, &block )
        add_step name, Ask.new(name, text:, &block)
      end

      def wait(name, &block )
        add_step name, Wait.new(name, &block)
      end

      private

      def add_step(name, step)
        @steps ||= {}
        name = name.to_s
        raise "Step with name #{name} is already exists" if @steps.key? name
        @steps[name] = step
      end
    end

    def initialize(from_id:, chat_id: nil, controller: nil, session: )
      @from_id = from_id
      @chat_id = chat_id
      @controller = controller
      @session = session
      @steps = {}
    end

    def process(action, args)
      debugger
    end

    private

    attr_reader :controller

  end
end
