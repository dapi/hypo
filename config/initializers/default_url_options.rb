# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.routes.default_url_options =
  Rails.application.config.action_controller.default_url_options =
    Rails.application.config.action_mailer.default_url_options = ApplicationConfig.default_url_options.symbolize_keys
