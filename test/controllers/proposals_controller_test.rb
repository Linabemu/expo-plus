require "test_helper"

class ProposalsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get proposals_create_url
    assert_response :success
  end
end
