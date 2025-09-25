module TelegramBot
  class Node
    attr_reader :name, :action_type, :content, :options

    def initialize(name, &block)
      @name = name
      @action_type = nil
      @content = nil
      @options = []
      @variable = nil
      @prompt = nil
      @store_as = nil
      @schema = nil

      instance_eval(&block) if block_given?
    end

    def message(text)
      @action_type = :message
      @content = text
    end

    def collect(variable, prompt: nil)
      @action_type = :collect
      @variable = variable
      @prompt = prompt
    end

    def menu(title: nil, &block)
      @action_type = :menu
      @title = title

      if block_given?
        @options = []
        instance_eval(&block)
      end
    end

    def option(text, to: nil)
      @options << { text: text, target: to }
    end

    def multi_select(items, store_as:)
      @action_type = :multi_select
      @items = items
      @store_as = store_as
    end

    def llm_extract(variable, &block)
      @action_type = :llm_extract
      @variable = variable

      if block_given?
        instance_eval(&block)
      end
    end

    def prompt(text)
      @prompt = text
    end

    def schema(&block)
      @schema = block
    end

    def integrate(service, &block)
      @action_type = :integrate
      @service = service

      if block_given?
        instance_eval(&block)
      end
    end
  end
end