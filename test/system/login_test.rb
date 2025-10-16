require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "user can sign in with valid credentials" do
    visit new_user_session_path
    
    fill_in "Email", with: "employee@example.com"
    fill_in "Password", with: "password"
    click_button "Log in"
    
    # Check that we're logged in
    assert_text "Hello, John"
    assert_text "Log out"
  end
end

