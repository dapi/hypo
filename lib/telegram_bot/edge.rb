module TelegramBot
  class Edge
    attr_reader :target, :condition, :data, :retry_count

    def initialize(target, options = {})
      @target = target
      @condition = options[:when] -> { true }
      @data = options[:data]
      @retry_count = options[:retry] || 0
      @attempts = 0
    end

    def can_retry?
      @attempts < @retry_count
    end

    def increment_attempts!
      @attempts += 1
    end

    def reset_attempts!
      @attempts = 0
    end
  end
end