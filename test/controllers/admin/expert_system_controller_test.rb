require "test_helper"

class Admin::ExpertSystemControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_expert_system_url
    assert_redirected_to root_url
  end

  test "index" do
    get admin_expert_system_url
    assert_response :success
  end
end
