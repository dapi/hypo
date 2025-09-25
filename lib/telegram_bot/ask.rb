module TelegramBot
  class Ask < Node
    def initialize(name, text:, on_answer:, &block)
      @text = text
      @on_answer = on_answer
      super name, &block
    end
  end
end
