require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  test "visiting the registration page" do
    visit new_user_registration_path
    
    assert_selector "h2", text: "Sign up"
    assert_selector "label", text: "Email"
    assert_selector "label", text: "Street"
    assert_selector "label", text: "City"
    assert_selector "label", text: "Zip"
    assert_selector "a", text: "← Back to Home"
    
    click_link "← Back to Home"
    assert_current_path root_path
  end

  test "signing up with valid information" do
    visit new_user_registration_path

    unique_email = "test#{Time.current.to_i}@example.com"
    fill_in "Email", with: unique_email
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

  test "navigating through authenticated pages" do
    # First sign up
    visit new_user_registration_path
    unique_email = "test#{Time.current.to_i}@example.com"
    fill_in "Email", with: unique_email
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    fill_in "Street", with: "123 Main St"
    fill_in "City", with: "Berlin"
    fill_in "Zip", with: "10115"
    click_button "Sign up"

    # Test navigation from landing to profile
    visit root_path
    assert_selector "a", text: "My Profile"
    click_link "My Profile"
    assert_current_path profile_path
    
    # Test back to home from profile
    assert_selector "a", text: "← Back to Home"
    click_link "← Back to Home"
    assert_current_path root_path

    # Test navigation to edit profile
    visit profile_path
    click_link "Edit Profile"
    assert_current_path edit_user_registration_path
    
    # Test back to home from edit profile
    assert_selector "a", text: "← Back to Home"
    click_link "← Back to Home"
    assert_current_path root_path
  end
end 