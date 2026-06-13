require "test_helper"

class Admin::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_reports_url
    assert_redirected_to root_url
  end

  test "index" do
    get admin_reports_url
    assert_response :success
  end
end
