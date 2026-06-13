require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @tour = tours(:one)
    sign_in_as(@user)
  end

  test "should get new with tour" do
    get new_booking_url(tour_id: @tour.id)
    assert_response :success
  end

  test "should create booking" do
    assert_difference("Booking.count") do
      post bookings_url, params: { booking: { tour_id: @tour.id, num_guests: 2, tour_date: Date.tomorrow } }
    end

    assert_redirected_to root_url
  end

  test "should create booking with add ons" do
    add_on = add_ons(:one)

    assert_difference("Booking.count") do
      post bookings_url, params: { booking: { tour_id: @tour.id, num_guests: 2, tour_date: Date.tomorrow, add_on_ids: [ add_on.id ] } }
    end

    booking = Booking.last
    assert_equal 1, booking.add_ons.count
    assert_redirected_to root_url
  end
end
