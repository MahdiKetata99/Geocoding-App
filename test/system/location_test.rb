require "application_system_test_case"

class LocationTest < ApplicationSystemTestCase
  def setup
    @user = users(:default_user)
    sign_in @user
  end

  test "displaying map on home page" do
    visit root_path

    assert_selector "h2", text: "Your Location"
    assert_selector "#map"
    assert_selector ".map-info"
    assert_selector ".coordinates"
  end

  test "displaying user's saved location on map" do
    @user.update(
      latitude: 52.520008,
      longitude: 13.404954,
      formatted_address: "Berlin, Germany",
      city: "Berlin",
      country: "Germany"
    )

    visit root_path

    assert_text "52.520008"
    assert_text "13.404954"
    assert_text "Berlin, Germany"
  end

  test "updating location from edit profile page" do
    visit edit_user_registration_path

    assert_selector "#map"
    assert_selector ".map-info"
    assert_no_text "This map shows your current saved location"
    assert_text "Drag the marker to update your address"
  end

  test "displaying location details" do
    @user.update(
      latitude: 52.520008,
      longitude: 13.404954,
      formatted_address: "Alexanderplatz, 10178 Berlin, Germany",
      street: "Alexanderplatz",
      city: "Berlin",
      zip: "10178",
      country: "Germany",
      federal_state: "Berlin",
      district: "Mitte"
    )

    visit root_path

    assert_selector ".location-details"
    assert_text "Geographic Coordinates"
    assert_text "52.520008"
    assert_text "13.404954"

    assert_text "Administrative Areas"
    assert_text "Federal State: Berlin"
    assert_text "District: Mitte"
    assert_text "Country: Germany"

    assert_text "Alexanderplatz"
    assert_text "Berlin"
    assert_text "10178"
  end
end
