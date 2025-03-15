require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  test "visiting the registration page" do
    visit new_user_registration_path
    
    assert_selector "h2", text: "Sign up"
    assert_selector "label", text: "Email"
    assert_selector "label", text: "Street"
    assert_selector "label", text: "City"
    assert_selector "label", text: "Zip"
  end

  test "signing up with valid information" do
    visit new_user_registration_path

    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    fill_in "Street", with: "123 Main St"
    fill_in "City", with: "Berlin"
    fill_in "Zip", with: "10115"

    click_button "Sign up"

    assert_text "Welcome"
    assert_text "123 Main St"
    assert_text "Berlin"
    assert_text "10115"
  end
end 