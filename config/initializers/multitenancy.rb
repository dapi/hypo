# frozen_string_literal: true

require 'multitenancy/elevator'
Rails.application.config.middleware.use Multitenancy::Elevator
# config.excluded_models = %w[Account User TelegramUser Script Argument NetworkToken Token Project Proxy ScriptNetwork]
