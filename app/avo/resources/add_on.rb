class Avo::Resources::AddOn < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :price, as: :number
    field :status, as: :select, enum: ::AddOn.statuses
    field :tour_id, as: :number
    field :tour, as: :belongs_to
    field :booking_add_ons, as: :has_many
    field :bookings, as: :has_many, through: :booking_add_ons
  end
end
