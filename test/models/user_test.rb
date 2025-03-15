require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test@example.com",
      password: "password123",
      street: "123 Main St",
      city: "Berlin",
      zip: "10115"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should require street" do
    @user.street = nil
    assert_not @user.valid?
  end

  test "should require city" do
    @user.city = nil
    assert_not @user.valid?
  end

  test "should require zip" do
    @user.zip = nil
    assert_not @user.valid?
  end

  test "should generate full address" do
    expected_address = "123 Main St, Berlin, 10115"
    assert_equal expected_address, @user.send(:full_address)
  end

  # test "the truth" do
  #   assert true
  # end
end
