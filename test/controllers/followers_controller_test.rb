require "test_helper"

class FollowersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get followers_create_url
    assert_response :success
  end

  test "should get new" do
    get followers_new_url
    assert_response :success
  end
end
