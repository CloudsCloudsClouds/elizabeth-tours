class Avo::Resources::BookingAddOn < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :add_on_id, as: :number
    field :booking_id, as: :number
    field :booking, as: :belongs_to
    field :add_on, as: :belongs_to
  end
end
