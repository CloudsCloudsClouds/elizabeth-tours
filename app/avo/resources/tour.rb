class Avo::Resources::Tour < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :base_price, as: :number
    field :add_ons, as: :has_many
    field :bookings, as: :has_many
  end
end
