require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:default_user)
  end

  test "should be valid with basic attributes" do
    assert @user.valid?
  end

  test "should allow setting location coordinates" do
    @user = User.new(
      email: "test1@example.com",
      password: "password123",
      street: "Friedrichstraße 123",
      city: "Berlin",
      zip: "10115"
    )
    @user.latitude = 52.520008
    @user.longitude = 13.404954
    assert @user.valid?
    assert_equal 52.520008, @user.latitude
    assert_equal 13.404954, @user.longitude
  end

  test "should allow setting address details" do
    @user = User.new(
      email: "test2@example.com",
      password: "password123"
    )
    @user.street = "Alexanderplatz"
    @user.city = "Berlin"
    @user.zip = "10178"
    @user.country = "Germany"
    @user.federal_state = "Berlin"
    @user.district = "Mitte"
    @user.formatted_address = "Alexanderplatz, 10178 Berlin, Germany"

    assert @user.valid?
    assert_equal "Alexanderplatz", @user.street
    assert_equal "Berlin", @user.city
    assert_equal "10178", @user.zip
    assert_equal "Germany", @user.country
    assert_equal "Berlin", @user.federal_state
    assert_equal "Mitte", @user.district
    assert_equal "Alexanderplatz, 10178 Berlin, Germany", @user.formatted_address
  end

  test "should allow nil values for location attributes" do
    @user = User.new(
      email: "test3@example.com",
      password: "password123"
    )
    @user.latitude = nil
    @user.longitude = nil
    @user.street = "Friedrichstraße 123"
    @user.city = "Berlin"
    @user.zip = "10115"
    @user.country = nil
    @user.federal_state = nil
    @user.district = nil
    @user.formatted_address = nil

    assert @user.valid?
  end

  test "should validate latitude range" do
    @user = User.new(
      email: "test4@example.com",
      password: "password123",
      street: "Friedrichstraße 123",
      city: "Berlin",
      zip: "10115"
    )
    @user.latitude = 91
    assert_not @user.valid?
    assert_includes @user.errors[:latitude], "must be between -90 and 90"

    @user.latitude = -91
    assert_not @user.valid?
    assert_includes @user.errors[:latitude], "must be between -90 and 90"

    @user.latitude = 45
    assert @user.valid?
  end

  test "should validate longitude range" do
    @user = User.new(
      email: "test5@example.com",
      password: "password123",
      street: "Friedrichstraße 123",
      city: "Berlin",
      zip: "10115"
    )
    @user.longitude = 181
    assert_not @user.valid?
    assert_includes @user.errors[:longitude], "must be between -180 and 180"

    @user.longitude = -181
    assert_not @user.valid?
    assert_includes @user.errors[:longitude], "must be between -180 and 180"

    @user.longitude = 90
    assert @user.valid?
  end

  test "should require street" do
    @user = User.new(
      email: "test6@example.com",
      password: "password123",
      city: "Berlin",
      zip: "10115"
    )
    assert_not @user.valid?
  end

  test "should require city" do
    @user = User.new(
      email: "test7@example.com",
      password: "password123",
      street: "Friedrichstraße 123",
      zip: "10115"
    )
    assert_not @user.valid?
  end

  test "should require zip" do
    @user = User.new(
      email: "test8@example.com",
      password: "password123",
      street: "Friedrichstraße 123",
      city: "Berlin"
    )
    assert_not @user.valid?
  end

  test "should generate full address" do
    @user = User.new(
      email: "test9@example.com",
      password: "password123",
      street: "Friedrichstraße 123",
      city: "Berlin",
      zip: "10115"
    )
    expected_address = "Friedrichstraße 123, Berlin, 10115, Germany"
    assert_equal expected_address, @user.send(:full_address)
  end
end
