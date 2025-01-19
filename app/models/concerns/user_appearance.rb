# frozen_string_literal: true

module UserAppearance
  def away
    Rails.logger.debug { "User appeared on #{away}" }
    # update! appearance: 'away'
  end

  def appear(on: nil)
    Rails.logger.debug { "User appeared on #{on}" }
    # update! appearance: 'appear'
  end

  def disappear
    Rails.logger.debug { "User appeared on #{disappear}" }
    # update! appearance: 'disappear'
  end
end
