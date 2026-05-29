class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :email_address, as: :text
    field :name, as: :text
    field :sessions, as: :has_many
    field :bookings, as: :has_many
    field :tours, as: :has_many, through: :bookings
  end
end
