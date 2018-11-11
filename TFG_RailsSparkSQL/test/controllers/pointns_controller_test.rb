require 'test_helper'

class PointnsControllerTest < ActionDispatch::IntegrationTest
  test "should get insert" do
    get pointns_insert_url
    assert_response :success
  end

end
