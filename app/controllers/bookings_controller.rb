class BookingsController < ApplicationController
  include Authentication
  allow_unauthenticated_access only: :new

  def new
    @booking = Booking.new
    @tour = Tour.find(params[:tour_id])
    @add_ons = @tour.add_ons.active
  end

  def create
    @tour = Tour.find(booking_params[:tour_id])
    @add_ons = @tour.add_ons.active

    begin
      booking = Booking.create_with_add_ons(
        user: Current.user,
        tour: @tour,
        num_guests: booking_params[:num_guests],
        tour_date: booking_params[:tour_date],
        add_on_ids: Array(booking_params[:add_on_ids]).reject(&:blank?),
        note: booking_params[:note]
      )
      redirect_to root_path, notice: "Booking was successfully created."
    rescue ActiveRecord::RecordInvalid => e
      @booking = @tour.bookings.build
      @booking.errors.add(:base, e.message)
      render :new, status: :unprocessable_content
    end
  end

  private
    def booking_params
      params.fetch(:booking, {}).permit(:tour_id, :num_guests, :tour_date, :note, add_on_ids: [])
    end
end
