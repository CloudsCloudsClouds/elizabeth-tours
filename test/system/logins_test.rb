require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  test "can sign in with valid credentials" do
    visit new_session_path

    fill_in "Email address", with: users(:one).email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    assert_current_path root_path
  end

  test "cannot sign in with invalid credentials" do
    visit new_session_path

    fill_in "Email address", with: users(:one).email_address
    fill_in "Password", with: "wrong"
    click_on "Sign in"

    assert_current_path new_session_path
    assert_text "Try another email address or password"
  end
end
