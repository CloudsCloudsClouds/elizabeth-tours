require "test_helper"

class Admin::BookingsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as_admin }

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_bookings_url
    assert_redirected_to root_url
  end

  test "index" do
    get admin_bookings_url
    assert_response :success
  end

  test "show" do
    get admin_booking_url(bookings(:one))
    assert_response :success
  end

  test "new" do
    get new_admin_booking_url
    assert_response :success
  end

  test "create" do
    assert_difference("Booking.count") do
      post admin_bookings_url, params: {
        booking: {
          user_id: users(:one).id,
          tour_id: tours(:one).id,
          num_guests: 2,
          tour_date: Date.tomorrow,
          status: "pending"
        }
      }
    end
    assert_redirected_to admin_booking_url(Booking.last)
  end

  test "edit" do
    get edit_admin_booking_url(bookings(:one))
    assert_response :success
  end

  test "update" do
    patch admin_booking_url(bookings(:one)), params: { booking: { status: "confirmed" } }
    assert_redirected_to admin_booking_url(bookings(:one))
    assert_equal "confirmed", bookings(:one).reload.status
  end

  test "destroy" do
    assert_difference("Booking.count", -1) do
      delete admin_booking_url(bookings(:one))
    end
    assert_redirected_to admin_bookings_url
  end
end
