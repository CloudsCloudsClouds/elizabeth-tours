class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    if params[:tour_id]
      @tour = Tour.find(params[:tour_id])
      @add_ons = @tour.add_ons.status_available
    end
  end

  # GET /bookings/1/edit
  def edit
    @tour = @booking.tour
    @add_ons = @tour.add_ons.status_available
  end

  # POST /bookings or /bookings.json
  def create
    @tour = Tour.find(booking_params[:tour_id])
    @add_ons = @tour.add_ons.status_available
    @booking = @tour.bookings.build(user: Current.user, note: booking_params[:note])

    respond_to do |format|
      begin
        booking = Booking.create_with_add_ons(
          user: Current.user,
          tour: @tour,
          add_on_ids: Array(booking_params[:add_on_ids]),
          note: booking_params[:note]
        )
        format.html { redirect_to booking, notice: "Booking was successfully created." }
        format.json { render :show, status: :created, location: booking }
      rescue ActiveRecord::RecordInvalid => e
        @booking.errors.add(:base, e.message)
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @booking.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "Booking was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @booking.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy!

    respond_to do |format|
      format.html { redirect_to bookings_path, notice: "Booking was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.fetch(:booking, {}).permit(:tour_id, :note, add_on_ids: [])
    end
end
