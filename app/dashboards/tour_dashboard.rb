require "administrate/base_dashboard"

class TourDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    add_ons: Field::HasMany,
    base_price: Field::Number.with_options(decimals: 2),
    bookings: Field::HasMany,
    description: Field::Text,
    description_es: Field::Text,
    images: Field::ActiveStorage,
    name: Field::String,
    name_es: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    base_price
    images
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    name_es
    description
    description_es
    base_price
    images
    add_ons
    bookings
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    name_es
    description
    description_es
    base_price
    images
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(tour)
    tour.name
  end
end
