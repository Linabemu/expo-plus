require "test_helper"

class WishesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get wishes_create_url
    assert_response :success
  end
end
