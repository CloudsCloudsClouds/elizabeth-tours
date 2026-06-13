require "administrate/base_dashboard"

class BookingDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    add_ons: Field::HasMany,
    booking_add_ons: Field::HasMany,
    note: Field::Text,
    num_guests: Field::Number,
    status: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    total_price: Field::Number.with_options(decimals: 2),
    tour: Field::BelongsTo,
    tour_date: Field::DateTime,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    user
    tour
    status
    tour_date
    total_price
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    tour
    status
    tour_date
    num_guests
    total_price
    note
    add_ons
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    user
    tour
    status
    tour_date
    num_guests
    total_price
    note
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(booking)
    "Booking ##{booking.id} - #{booking.tour&.name}"
  end
end
