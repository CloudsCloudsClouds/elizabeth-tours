class Avo::Resources::Booking < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :tour, as: :belongs_to
    # TODO figure out why enum doesn't display
    field :status, as: :select, enum: ::Booking.statuses
    field :tour_date, as: :date_time
    field :num_guests, as: :number
    # TODO replace number by money
    field :total_price, as: :number
    field :note, as: :textarea
  end

  def actions
    action Avo::Actions::ExportBookings
  end
end
