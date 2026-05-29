class Avo::Resources::Booking < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :note, as: :textarea
    field :status, as: :select, enum: ::Booking.statuses
    field :total_price, as: :number
    field :tour_id, as: :number
    field :user_id, as: :number
    field :user, as: :belongs_to
    field :tour, as: :belongs_to
    field :booking_add_ons, as: :has_many
    field :add_ons, as: :has_many, through: :booking_add_ons
  end
end
