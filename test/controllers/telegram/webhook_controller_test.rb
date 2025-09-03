require "test_helper"

class Telegram::WebhookControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bot = Minitest::Mock.new
    @bot.expect :token, "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"

    @controller = Telegram::WebhookController.new
    @controller.instance_variable_set(:@bot, @bot)

    # Mock chat data
    @chat_data = {
      "id" => Random.rand(1..100_000),
      "first_name" => "Danil",
      "last_name" => "Pismenny",
      "username" => "pismenny",
      "type" => "private"
    }

    @telegram_user = TelegramUser.create!(
      id: @chat_data["id"],
      first_name: @chat_data["first_name"],
      last_name: @chat_data["last_name"],
      username: @chat_data["username"]
    )
  end

  teardown do
    @bot.verify
  end

  test "start command without auth token responds with login URL" do
    # Setup controller state
    @controller.instance_variable_set(:@chat, @chat_data)
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    # Mock respond_with call
    expected_text = "Привет! Чтобы авторизоваться перейдите на сайт: #{Rails.application.routes.url_helpers.new_session_url}"

    response_mock = Minitest::Mock.new
    response_mock.expect :call, nil, [:message, { text: expected_text }]
    @controller.stub :respond_with, response_mock do
      @controller.start!
    end

    response_mock.verify
  end

  test "start command with auth token generates login token and responds with confirm URL" do
    # Setup auth token
    auth_token = "some_auth_session_token"
    word = "#{ApplicationHelper::AUTH_PREFIX}#{auth_token}"

    # Setup controller state
    @controller.instance_variable_set(:@chat, @chat_data)
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    # Mock the verifier and token generation
    verifier = Rails.application.message_verifier(:telegram)
    generated_token = nil

    response_mock = Minitest::Mock.new
    response_mock.expect :call, nil do |type, options|
      assert_equal :message, type
      assert_includes options[:text], "Вы авторизованы!"
      assert_includes options[:text], "telegram_confirm_url"
      generated_token = options[:text].match(/token=([^&\s]+)/)[1]
      true
    end

    @controller.stub :respond_with, response_mock do
      @controller.start!(word)
    end

    response_mock.verify

    # Verify that the token can be decoded and contains expected data
    assert_not_nil generated_token
    decoded_data = verifier.verify(generated_token, purpose: :login)
    assert_equal auth_token, decoded_data[:st]
    assert_equal @telegram_user.id, decoded_data[:tid]
    assert_kind_of Integer, decoded_data[:t]
  end

  test "start command with auth token but invalid prefix falls back to regular greeting" do
    # Setup invalid auth token (without proper prefix)
    word = "invalid_auth_token"

    # Setup controller state
    @controller.instance_variable_set(:@chat, @chat_data)
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    expected_text = "Привет! Чтобы авторизоваться перейдите на сайт: #{Rails.application.routes.url_helpers.new_session_url}"

    response_mock = Minitest::Mock.new
    response_mock.expect :call, nil, [:message, { text: expected_text }]

    @controller.stub :respond_with, response_mock do
      @controller.start!(word)
    end

    response_mock.verify
  end

  test "start command creates or finds telegram user" do
    # Test telegram_user helper method
    @controller.instance_variable_set(:@chat, @chat_data)

    # Clear existing telegram user to test creation
    TelegramUser.destroy_all

    result = @controller.send(:telegram_user)

    assert_not_nil result
    assert_equal @chat_data["id"], result.id
    assert_equal @chat_data["first_name"], result.first_name
    assert_equal @chat_data["last_name"], result.last_name
    assert_equal @chat_data["username"], result.username

    # Test that subsequent calls return the same record
    result2 = @controller.send(:telegram_user)
    assert_equal result.id, result2.id
  end

  test "start command with multiple words processes only first word" do
    # Setup auth token with additional words
    auth_token = "some_auth_session_token"
    word = "#{ApplicationHelper::AUTH_PREFIX}#{auth_token}"
    other_words = ["extra", "arguments"]

    # Setup controller state
    @controller.instance_variable_set(:@chat, @chat_data)
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    response_mock = Minitest::Mock.new
    response_mock.expect :call, nil do |type, options|
      assert_equal :message, type
      assert_includes options[:text], "Вы авторизованы!"
      true
    end

    @controller.stub :respond_with, response_mock do
      @controller.start!(word, *other_words)
    end

    response_mock.verify
  end

  test "current_bot_id extracts bot ID from token" do
    result = @controller.send(:current_bot_id)
    assert_equal "123456", result
  end

  private

  def setup_telegram_webhook_environment
    # Helper method to setup common webhook test environment
    Rails.application.config.telegram_webhook_token = "test_webhook_token"
  end
end
