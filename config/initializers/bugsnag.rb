Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY", "7a189150a2ca438b5e62b3d906ddaf59")
  config.app_version = AppVersion.format("%M.%m.%p")
  config.notify_release_stages = %w[production]
  config.send_code = true
  config.send_environment = true
end
