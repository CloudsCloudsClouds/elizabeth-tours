class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  has_many :booking_add_ons, dependent: :destroy
  has_many :add_ons, through: :booking_add_ons

  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled" }
  validates :num_guests, presence: true, numericality: { greater_than: 0 }
  validates :tour_date, presence: true


  class << self
    # Creates a booking for a user with the specified tour and optional add-ons.
    #
    # @param user [User] the user making the booking
    # @param tour [Tour] the tour to book
    # @param num_guests [Integer] number of guests
    # @param tour_date [DateTime] date of the tour
    # @param add_on_ids [Array<Integer>] IDs of add-ons to include (must belong to the tour)
    # @param note [String, nil] optional note for the booking
    # @return [Booking] the created booking with associated add-ons
    # @raise [ActiveRecord::RecordInvalid] if any add_on_id does not belong to the tour
    #
    # @example Create a basic booking
    #   Booking.create_with_add_ons(user: user, tour: tour, num_guests: 2, tour_date: Date.tomorrow)
    #
    # @example Create a booking with add-ons
    #   Booking.create_with_add_ons(user: user, tour: tour, num_guests: 2, tour_date: Date.tomorrow, add_on_ids: [1, 2, 3])
    #
    # @example Create a booking with add-ons and a note
    #   Booking.create_with_add_ons(user: user, tour: tour, num_guests: 2, tour_date: Date.tomorrow, add_on_ids: [1], note: "Special requests")
    #
    # @note All add-ons must belong to the specified tour. This is validated before creation.
    # @note The transaction ensures atomicity - either all records are created or none.
    # @note The booking status is automatically set to :pending.
    # @note Total price is calculated as: tour.base_price + sum(add_ons.prices)
    def create_with_add_ons(user:, tour:, num_guests:, tour_date:, add_on_ids: [], note: nil)
      add_ons = AddOn.where(id: add_on_ids, tour_id: tour.id).to_a

      raise ActiveRecord::RecordInvalid, add_ons.first if add_ons.size != add_on_ids.size

      total_price = tour.base_price.to_d + add_ons.sum { |ao| ao.price.to_d }

      transaction do
        booking = create!(
          user: user,
          tour: tour,
          num_guests: num_guests,
          tour_date: tour_date,
          note: note,
          status: :pending,
          total_price: total_price
        )

        add_ons.each do |add_on|
          booking.booking_add_ons.create!(add_on: add_on)
        end

        booking
      end
    end
  end
end
