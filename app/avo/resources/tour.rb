class Avo::Resources::Tour < Avo::BaseResource
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
    field :name, as: :text
    field :name_es, as: :text, name: "Nombre (ES)"
    field :description, as: :textarea
    field :description_es, as: :textarea, name: "Descripción (ES)"
    # TODO replace number by money
    field :base_price, as: :number
    field :images, as: :files, is_image: true
  end
end
