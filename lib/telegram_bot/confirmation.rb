module TelegramBot
  class Confirmation < Node
    def initialize(name, text:, on_confirm:, &block)
      @text = text
      @on_confirm = on_confirm
      super name, &block
    end
  end
end
