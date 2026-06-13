require "test_helper"

class Admin::AddOnsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_add_ons_url
    assert_redirected_to root_url
  end

  test "index" do
    get admin_add_ons_url
    assert_response :success
  end

  test "show" do
    get admin_add_on_url(add_ons(:one))
    assert_response :success
  end

  test "new" do
    get new_admin_add_on_url
    assert_response :success
  end

  test "create" do
    assert_difference("AddOn.count") do
      post admin_add_ons_url, params: { add_on: { name: "New AddOn", tour_id: tours(:one).id, price: 25, active: true } }
    end
    assert_redirected_to admin_add_on_url(AddOn.last)
  end

  test "edit" do
    get edit_admin_add_on_url(add_ons(:one))
    assert_response :success
  end

  test "update" do
    patch admin_add_on_url(add_ons(:one)), params: { add_on: { name: "Updated" } }
    assert_redirected_to admin_add_on_url(add_ons(:one))
    assert_equal "Updated", add_ons(:one).reload.name
  end

  test "destroy" do
    assert_difference("AddOn.count", -1) do
      delete admin_add_on_url(add_ons(:one))
    end
    assert_redirected_to admin_add_ons_url
  end
end
