require "test_helper"

class Admin::ExpertSystemControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_expert_system_url
    assert_redirected_to root_url
  end

  test "index renders form" do
    get admin_expert_system_url
    assert_response :success
    assert_select "h1", /Sistema Experto/
  end

  test "shows error when EXPT_LINK is not set" do
    orig = ENV.delete("EXPT_LINK")
    get admin_expert_system_url, params: { gravity: 3, fuel_severity: 2, description: "Test" }
    assert_response :success
    assert_select ".text-red-600", /EXPT_LINK/
  ensure
    ENV["EXPT_LINK"] = orig
  end
end
