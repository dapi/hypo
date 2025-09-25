require "test_helper"

class HypoBotTest < ActiveSupport::TestCase
  test "initializable" do
    controller = Minitest::Mock.new
    controller.expect :current_user, nil
    assert HypoBot.new user_id: 1, controller: controller
  end
end
