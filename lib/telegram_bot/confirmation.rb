module TelegramBot
  class Confirmation < Node
    def initialize(name, text:, &block)
      @text = text
      super name, &block
    end
  end
end
