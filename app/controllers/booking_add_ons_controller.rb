class BookingAddOnsController < ApplicationController
  before_action :set_booking_add_on, only: %i[ show edit update destroy ]

  # GET /booking_add_ons or /booking_add_ons.json
  def index
    @booking_add_ons = BookingAddOn.all
  end

  # GET /booking_add_ons/1 or /booking_add_ons/1.json
  def show
  end

  # GET /booking_add_ons/new
  def new
    @booking_add_on = BookingAddOn.new
  end

  # GET /booking_add_ons/1/edit
  def edit
  end

  # POST /booking_add_ons or /booking_add_ons.json
  def create
    @booking_add_on = BookingAddOn.new(booking_add_on_params)

    respond_to do |format|
      if @booking_add_on.save
        format.html { redirect_to @booking_add_on, notice: "Booking add on was successfully created." }
        format.json { render :show, status: :created, location: @booking_add_on }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @booking_add_on.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /booking_add_ons/1 or /booking_add_ons/1.json
  def update
    respond_to do |format|
      if @booking_add_on.update(booking_add_on_params)
        format.html { redirect_to @booking_add_on, notice: "Booking add on was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @booking_add_on }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @booking_add_on.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /booking_add_ons/1 or /booking_add_ons/1.json
  def destroy
    @booking_add_on.destroy!

    respond_to do |format|
      format.html { redirect_to booking_add_ons_path, notice: "Booking add on was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking_add_on
      @booking_add_on = BookingAddOn.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def booking_add_on_params
      params.fetch(:booking_add_on, {}).permit(:booking_id, :add_on_id)
    end
end
