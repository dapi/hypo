source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "state_machines-activerecord"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
#
gem "semver2", github: "haf/semver"
gem "slim-rails"

group :development, :test do
  gem "dip", "~> 8.2.5"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "guard"
  gem "listen"
  gem "terminal-notifier-guard"

  gem "guard-ctags-bundler"
  gem "guard-minitest"
  gem "guard-rails"
  gem "guard-rubocop", "~> 1.5"
  gem "guard-shell", "~> 0.7.2"

  gem "letter_opener_web"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "nanoid", "~> 2.0"

gem "request_store", "~> 1.7"

gem "active_link_to", "~> 1.0"

gem "cssbundling-rails", "~> 1.4"

gem "anyway_config", "~> 2.7"

gem "sorcery", "~> 0.17.0"

gem "rhelm", "~> 0.2.0"

gem "zstd-ruby", "~> 1.5"

gem "solid_queue_dashboard", "~> 0.2.0"

gem "simple_form", "~> 5.3"

gem "strip_attributes", "~> 2.0"

gem "kaminari", "~> 1.2"

gem "ransack", "~> 4.3"

gem "draper", "~> 4.0"

gem "bootstrap-icons-helper", "~> 2.0"

gem "administrate", github: "thoughtbot/administrate"

gem "faker", "~> 3.5"

gem "redis", "~> 5.4"

gem "bugsnag", "~> 6.27"

gem "rails-i18n", "~> 8.0"

gem "telegram-bot", github: "telegram-bot-rb/telegram-bot"

gem "hiredis", "~> 0.6.3"

gem "mutex_m", "~> 0.3.0"

gem "net-smtp", "~> 0.5.0"

gem "mailgun-ruby", "~> 1.3"

gem "rb-gravatar", "~> 1.0"

gem "yabeda", "~> 0.13.1"

gem "yabeda-rails", "~> 0.9.0"

gem "yabeda-prometheus-mmap"

gem "yabeda-puma-plugin"

gem "yabeda-activerecord", "~> 0.1.1"

gem "rack-cors", "~> 2.0"

# gem "activerecord_json_validator", "~> 3.1"

gem "valid_email", "~> 0.2.1"

# Crypto address validator
# gem "adequate_crypto_address", "~> 0.1.9"
#
gem "bip44", github: "dapi/bip44"

# gem 'eth', '~> 0.5.11'
# gem "eth", github: "dapi/eth.rb", branch: "fix_get_balance_with_block_number"
# gem "bitcoin-ruby", git: "https://github.com/lian/bitcoin-ruby", branch: "master", require: "bitcoin"
gem "derivator", "~> 0.1"
