# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: "_hypo_session",
                                       domain:  ApplicationConfig.cookie_domain,
                                       tld_length: ApplicationConfig.tld_length
