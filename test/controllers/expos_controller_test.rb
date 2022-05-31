require "test_helper"

class ExposControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get expos_index_url
    assert_response :success
  end

  test "should get show" do
    get expos_show_url
    assert_response :success
  end
end
