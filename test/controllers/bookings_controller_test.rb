require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
    @user = users(:one)
    @tour = tours(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get bookings_url
    assert_response :success
  end

  test "should get new" do
    get new_booking_url
    assert_response :success
  end

  test "should get new with tour" do
    get new_booking_url(tour_id: @tour.id)
    assert_response :success
  end

  test "should create booking" do
    assert_difference("Booking.count") do
      post bookings_url, params: { booking: { tour_id: @tour.id } }
    end

    assert_redirected_to booking_url(Booking.last)
  end

  test "should create booking with add ons" do
    add_on = add_ons(:one)

    assert_difference("Booking.count") do
      post bookings_url, params: { booking: { tour_id: @tour.id, add_on_ids: [ add_on.id ] } }
    end

    booking = Booking.last
    assert_equal 1, booking.add_ons.count
    assert_redirected_to booking_url(booking)
  end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
  end

  test "should get edit" do
    get edit_booking_url(@booking)
    assert_response :success
  end

  test "should update booking" do
    patch booking_url(@booking), params: { booking: {} }
    assert_redirected_to booking_url(@booking)
  end

  test "should destroy booking" do
    assert_difference("Booking.count", -1) do
      delete booking_url(@booking)
    end

    assert_redirected_to bookings_url
  end
end
