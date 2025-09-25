class TelegramSession
  def initialize(telegram_user)
    @telegram_user = telegram_user
    @data = ActiveSupport::HashWithIndifferentAccess.new telegram_user.session_data
  end

  delegate :[], :[]=, :keys, :key?, :delete, to: :data

  def commit
    @telegram_user.update! session_data: @data unless @telegram_user.session_data == @data
  end

  private

  attr_reader :data
end
