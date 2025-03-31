require "test_helper"

class SignInMailerTest < ActionMailer::TestCase
  test "send_code" do
    mail = SignInMailer.with(email: "to@example.org", code: "123").send_code
    assert_equal "Send code", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    # assert_equal [ "from@example.com" ], mail.from
    # assert_match "123", mail.body.encoded
  end
end
