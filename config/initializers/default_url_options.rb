# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

default_url_options = if Rails.env.test?
                        {
                          host: "example.com"
                        }
else
                        {
                          host: ApplicationConfig.host,
                          protocol: ApplicationConfig.protocol
                        }
end
Rails.application.routes.default_url_options =
  Rails.application.config.action_controller.default_url_options =
    Rails.application.config.action_mailer.default_url_options = default_url_options
