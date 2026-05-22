require "test_helper"

class BookingAddOnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking_add_on = booking_add_ons(:one)
  end

  test "should get index" do
    get booking_add_ons_url
    assert_response :success
  end

  test "should get new" do
    get new_booking_add_on_url
    assert_response :success
  end

  test "should create booking_add_on" do
    assert_difference("BookingAddOn.count") do
      post booking_add_ons_url, params: { booking_add_on: {} }
    end

    assert_redirected_to booking_add_on_url(BookingAddOn.last)
  end

  test "should show booking_add_on" do
    get booking_add_on_url(@booking_add_on)
    assert_response :success
  end

  test "should get edit" do
    get edit_booking_add_on_url(@booking_add_on)
    assert_response :success
  end

  test "should update booking_add_on" do
    patch booking_add_on_url(@booking_add_on), params: { booking_add_on: {} }
    assert_redirected_to booking_add_on_url(@booking_add_on)
  end

  test "should destroy booking_add_on" do
    assert_difference("BookingAddOn.count", -1) do
      delete booking_add_on_url(@booking_add_on)
    end

    assert_redirected_to booking_add_ons_url
  end
end
