require "test_helper"

class MyPayslipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get my_payslips_index_url
    assert_response :success
  end
end
