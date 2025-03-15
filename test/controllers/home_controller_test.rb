require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:default_user)
  end

  test "should get index when not logged in" do
    get root_url
    assert_response :success
    assert_select "a[href=?]", new_user_registration_path
    assert_select "a[href=?]", new_user_session_path
  end

  test "should get index when logged in" do
    sign_in @user
    get root_url
    assert_response :success
    assert_select "a[href=?]", profile_path
    assert_select "form[action=?]", destroy_user_session_path
  end

  test "should not get profile when not logged in" do
    get profile_url
    assert_redirected_to new_user_session_path
  end

  test "should get profile when logged in" do
    sign_in @user
    get profile_url
    assert_response :success
    assert_select "h1", /Welcome, #{@user.email}/
    assert_select "a[href=?]", root_path, text: /← Back to Home/
  end
end
