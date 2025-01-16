# frozen_string_literal: true

require "multitenancy/elevator"
Rails.application.config.middleware.use Multitenancy::Elevator
