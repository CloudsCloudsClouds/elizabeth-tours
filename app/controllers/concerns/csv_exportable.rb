module CsvExportable
  extend ActiveSupport::Concern

  included do
    before_action :handle_csv_format, only: :index
  end

  private

  def handle_csv_format
    export_csv if request.format.csv?
  end

  def export_csv
    internal_columns = %w[id created_at updated_at password_digest]
    columns = resource_class.columns.reject { |c| c.name.in?(internal_columns) }

    csv = CSV.generate(headers: true) do |rows|
      rows << columns.map { |c| column_header(c.name) }

      resource_class.find_each do |record|
        rows << columns.map { |c| record.send(c.name) }
      end
    end

    filename = "#{resource_name}_#{Time.current.to_i}.csv"
    send_data csv, filename: filename, type: "text/csv"
  end

  def column_header(name)
    I18n.t("admin.field_translations.#{name}", default: name.humanize)
  end
end
