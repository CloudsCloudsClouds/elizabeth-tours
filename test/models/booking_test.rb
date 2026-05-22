require "test_helper"

class BookingTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @tour = tours(:one)
    @add_on = add_ons(:one)
  end

  test "creates booking with correct total_price" do
    total_price = @tour.base_price + @add_on.price

    booking = Booking.create_with_add_ons(
      user: @user,
      tour: @tour,
      add_on_ids: [ @add_on.id ]
    )

    assert booking.persisted?
    assert_equal total_price, booking.total_price.to_f
    assert_equal "pending", booking.status
    assert_equal @user, booking.user
    assert_equal @tour, booking.tour
    assert_includes booking.add_ons, @add_on
  end

  test "creates booking with no add_ons" do
    booking = Booking.create_with_add_ons(
      user: @user,
      tour: @tour
    )

    assert booking.persisted?
    assert_equal @tour.base_price, booking.total_price.to_f
    assert_empty booking.add_ons
  end

  test "creates booking with multiple add_ons" do
    second_add_on = add_ons(:two)
    second_add_on.update!(tour: @tour)

    total_price = @tour.base_price + @add_on.price + second_add_on.price

    booking = Booking.create_with_add_ons(
      user: @user,
      tour: @tour,
      add_on_ids: [ @add_on.id, second_add_on.id ]
    )

    assert_equal total_price, booking.total_price.to_f
    assert_equal 2, booking.add_ons.count
  end

  test "raises error when add_on belongs to different tour" do
    other_tour = tours(:two)
    other_add_on = add_ons(:two)
    other_add_on.update!(tour: other_tour)

    assert_raises(ActiveRecord::RecordInvalid) do
      Booking.create_with_add_ons(
        user: @user,
        tour: @tour,
        add_on_ids: [ other_add_on.id ]
      )
    end
  end

  test "raises error when add_on does not exist" do
    non_existent_id = AddOn.maximum(:id).to_i + 100

    assert_raises(ActiveRecord::RecordInvalid) do
      Booking.create_with_add_ons(
        user: @user,
        tour: @tour,
        add_on_ids: [ non_existent_id ]
      )
    end
  end

  test "transaction rollback on failure" do
    initial_booking_count = Booking.count

    assert_raises(ActiveRecord::RecordInvalid) do
      Booking.create_with_add_ons(
        user: @user,
        tour: @tour,
        add_on_ids: [ 99999 ]
      )
    end

    assert_equal initial_booking_count, Booking.count
  end

  test "booking includes note" do
    booking = Booking.create_with_add_ons(
      user: @user,
      tour: @tour,
      note: "Special requests"
    )
    assert_equal "Special requests", booking.note
  end

  test "handles nil price on add_on" do
    @add_on.update!(price: nil)

    booking = Booking.create_with_add_ons(
      user: @user,
      tour: @tour,
      add_on_ids: [ @add_on.id ]
    )

    assert_equal @tour.base_price, booking.total_price.to_f
  end
end
