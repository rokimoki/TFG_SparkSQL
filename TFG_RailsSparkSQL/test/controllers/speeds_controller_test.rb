require 'test_helper'

class SpeedsControllerTest < ActionDispatch::IntegrationTest
  test "should get insert" do
    get speeds_insert_url
    assert_response :success
  end

end
