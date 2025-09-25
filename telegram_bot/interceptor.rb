module TelegramBot
  class Interceptor
    attr_reader :pattern, :block

    def initialize(pattern, block)
      @pattern = pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern, Regexp::IGNORECASE)
      @block = block
    end

    def match?(text)
      text.match?(@pattern)
    end
  end
end