require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_users_url
    assert_redirected_to root_url
  end

  test "index" do
    get admin_users_url
    assert_response :success
  end

  test "new" do
    get new_admin_user_url
    assert_response :success
  end

  test "edit" do
    get edit_admin_user_url(users(:one))
    assert_response :success
  end

  test "update" do
    patch admin_user_url(users(:one)), params: { user: { name: "Updated" } }
    assert_redirected_to admin_user_url(users(:one))
    assert_equal "Updated", users(:one).reload.name
  end

  test "destroy" do
    assert_difference("User.count", -1) do
      delete admin_user_url(users(:one))
    end
    assert_redirected_to admin_users_url
  end
end
