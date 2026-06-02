require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    visit new_session_path
    fill_in "Email address", with: users(:one).email_address
    fill_in "Password", with: "password"
    click_on "Sign in"
  end

  test "can create a booking" do
    assert_text "Logout"

    tour = tours(:one)
    visit new_booking_path(tour_id: tour.id)

    fill_in "Number of guests", with: "2"
    page.execute_script("document.getElementById('booking_tour_date').value = '#{Date.tomorrow.iso8601}'")
    click_on "Confirm booking"

    assert_current_path root_path
    assert_text "Booking was successfully created"
  end

  test "can create a booking with add-on" do
    assert_text "Logout"

    tour = tours(:one)
    add_on = add_ons(:one)
    visit new_booking_path(tour_id: tour.id)

    fill_in "Number of guests", with: "2"
    page.execute_script("document.getElementById('booking_tour_date').value = '#{Date.tomorrow.iso8601}'")
    check add_on.name
    click_on "Confirm booking"

    assert_current_path root_path
    assert_text "Booking was successfully created"
    assert Booking.last.add_ons.include?(add_on)
  end
end
