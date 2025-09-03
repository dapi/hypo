require "test_helper"
require "ostruct"

class Telegram::WebhookControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controller = Telegram::WebhookController.new

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

  test "start command without auth token responds with login URL" do
    # Setup controller state
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    # Mock respond_with call
    expected_text = "Привет! Чтобы авторизоваться перейдите на сайт: #{Rails.application.routes.url_helpers.new_session_url}"

    response_called = false
    @controller.stub :respond_with, ->(type, options) {
      assert_equal :message, type
      assert_equal expected_text, options[:text]
      response_called = true
    } do
      @controller.start!(nil)
    end

    assert response_called, "respond_with was not called"
  end

  test "start command with auth token generates login token and responds with confirm URL" do
    # Setup auth token
    auth_token = "some_session_token"
    word = "#{ApplicationHelper::AUTH_PREFIX}#{auth_token}"

    # Setup controller state
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    # Mock the verifier and token generation
    verifier = Rails.application.message_verifier(:telegram)
    generated_token = nil
    response_called = false

    @controller.stub :respond_with, ->(type, options) {
      assert_equal :message, type
      assert_includes options[:text], "Вы авторизованы!"
      assert_includes options[:text], "/telegram/confirm"
      generated_token = options[:text].match(/token=([^&\s]+)/)[1]
      response_called = true
    } do
      @controller.start!(word)
    end

    assert response_called, "respond_with was not called"

    # Verify that the token can be decoded and contains expected data
    assert_not_nil generated_token, "Generated token should not be nil"
    decoded_data = verifier.verify(generated_token, purpose: :login)
    assert_equal auth_token, decoded_data["st"]
    assert_equal @telegram_user.id.to_s, decoded_data["tid"].to_s
    assert_kind_of Integer, decoded_data["t"]
  end

  test "start command with auth token but invalid prefix falls back to regular greeting" do
    # Setup invalid auth token (without proper prefix)
    word = "invalid_auth_token"

    # Setup controller state
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    expected_text = "Привет! Чтобы авторизоваться перейдите на сайт: #{Rails.application.routes.url_helpers.new_session_url}"

    response_called = false
    @controller.stub :respond_with, ->(type, options) {
      assert_equal :message, type
      assert_equal expected_text, options[:text]
      response_called = true
    } do
      @controller.start!(word)
    end

    assert response_called, "respond_with was not called"
  end

  test "start command creates or finds telegram user" do
    # Clear existing telegram user to test creation
    TelegramUser.destroy_all

    # Mock the chat method to return our data
    @controller.stub :chat, @chat_data do
      result = @controller.send(:telegram_user)

      assert_not_nil result
      assert_equal @chat_data["id"].to_s, result.id.to_s
      assert_equal @chat_data["first_name"], result.first_name
      assert_equal @chat_data["last_name"], result.last_name
      assert_equal @chat_data["username"], result.username

      # Test that subsequent calls return the same record
      result2 = @controller.send(:telegram_user)
      assert_equal result.id, result2.id
    end
  end

  test "start command with multiple words processes only first word" do
    # Setup auth token with additional words
    auth_token = "some_session_token"
    word = "#{ApplicationHelper::AUTH_PREFIX}#{auth_token}"
    other_words = [ "extra", "arguments" ]

    # Setup controller state
    @controller.instance_variable_set(:@telegram_user, @telegram_user)

    response_called = false
    @controller.stub :respond_with, ->(type, options) {
      assert_equal :message, type
      assert_includes options[:text], "Вы авторизованы!"
      response_called = true
    } do
      @controller.start!(word, *other_words)
    end

    assert response_called, "respond_with was not called"
  end

  test "current_bot_id extracts bot ID from token" do
    # Mock bot with token
    bot_mock = OpenStruct.new(token: "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11")

    @controller.stub :bot, bot_mock do
      result = @controller.send(:current_bot_id)
      assert_equal "123456", result
    end
  end
end
