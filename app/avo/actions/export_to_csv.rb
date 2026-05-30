class Avo::Actions::ExportToCsv < Avo::BaseAction
  self.name = "Export to CSV"
  self.may_download_file = true

  def handle(records:, **args)
    internal_columns = %w[id created_at updated_at password_digest]
    columns = records.klass.columns.reject { |c| c.name.in?(internal_columns) }

    csv = CSV.generate(headers: true) do |rows|
      rows << columns.map { |c| column_header(c.name) }

      records.find_each do |record|
        rows << columns.map { |c| record.send(c.name) }
      end
    end

    download(csv, "#{records.klass.model_name.route_key}_#{Time.current.to_i}.csv")
  end

  private

  def column_header(name)
    I18n.t("avo.field_translations.#{name}", default: name.humanize)
  end
end
