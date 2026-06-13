require "administrate/base_dashboard"

class AddOnDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    active: Field::Boolean,
    booking_add_ons: Field::HasMany,
    bookings: Field::HasMany,
    name: Field::String,
    name_es: Field::String,
    price: Field::Number.with_options(decimals: 2),
    tour: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    tour
    price
    active
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    name_es
    tour
    price
    active
    bookings
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    name_es
    tour
    price
    active
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(add_on)
    add_on.name
  end
end
