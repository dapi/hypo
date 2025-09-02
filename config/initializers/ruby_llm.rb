RubyLLM.configure do |config|
  config.deepseek_api_key = ApplicationConfig.deepseek_api_key
  # config.openai_api_key = ENV["OPENAI_API_KEY"]
  # config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"]

  config.default_model = ApplicationConfig.llm_default_model
end
