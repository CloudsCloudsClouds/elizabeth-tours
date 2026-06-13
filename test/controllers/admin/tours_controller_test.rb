require "test_helper"

class Admin::ToursControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_tours_url
    assert_redirected_to root_url
    assert_equal "You must be an admin to access this page.", flash[:alert]
  end

  test "index" do
    get admin_tours_url
    assert_response :success
  end

  test "show" do
    get admin_tour_url(tours(:one))
    assert_response :success
  end

  test "new" do
    get new_admin_tour_url
    assert_response :success
  end

  test "create" do
    assert_difference("Tour.count") do
      post admin_tours_url, params: { tour: { name: "New Tour", description: "Description", base_price: 100 } }
    end
    assert_redirected_to admin_tour_url(Tour.last)
  end

  test "edit" do
    get edit_admin_tour_url(tours(:one))
    assert_response :success
  end

  test "update" do
    patch admin_tour_url(tours(:one)), params: { tour: { name: "Updated" } }
    assert_redirected_to admin_tour_url(tours(:one))
    assert_equal "Updated", tours(:one).reload.name
  end

  test "destroy" do
    assert_difference("Tour.count", -1) do
      delete admin_tour_url(tours(:one))
    end
    assert_redirected_to admin_tours_url
  end
end
