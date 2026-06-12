require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    bookings: Field::HasMany,
    email_address: Field::String,
    name: Field::String,
    role: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    sessions: Field::HasMany,
    tours: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    email_address
    name
    role
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    email_address
    name
    role
    sessions
    bookings
    tours
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    email_address
    name
    role
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(user)
    user.name.presence || user.email_address
  end
end
