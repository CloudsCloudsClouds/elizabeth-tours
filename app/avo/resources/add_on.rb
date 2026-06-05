class Avo::Resources::AddOn < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def actions
    action Avo::Actions::ExportToCsv
  end

  def fields
    field :id, as: :id
    field :tour, as: :belongs_to
    field :name, as: :text
    field :name_es, as: :text, name: "Nombre (ES)"
    # TODO replace number by money
    field :price, as: :number
    field :active, as: :boolean, true_value: "1", false_value: "0"
  end
end
