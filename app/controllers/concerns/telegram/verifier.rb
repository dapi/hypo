module Telegram::Verifier
  private
  def verifier
    @verifier ||= Rails.application.message_verifier :telegram
  end
end
