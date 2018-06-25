require 'test_helper'

class ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get get_moves" do
    get imports_get_moves_url
    assert_response :success
  end

  test "should get unmarshall" do
    get imports_unmarshall_url
    assert_response :success
  end

end
