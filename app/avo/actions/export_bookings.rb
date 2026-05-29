class Avo::Actions::ExportBookings < Avo::BaseAction
  self.name = "Export bookings to csv"
  self.may_download_file = true

  def handle(records:, **args)
    require "csv"

    csv = CSV.generate(headers: true) do |row|
      # Column headers
      row << [ "ID", "Usuario", "Tour", "Estado", "Precio Total", "Notas", "Creado el" ]

      records.each do |booking|
        # Mapping attributes to CSV columns
        row << [
          booking.id,
          booking.user&.name,
          booking.tour&.name,
          booking.status,
          booking.total_price,
          booking.note,
          booking.created_at
        ]
      end
    end

    download(csv, "reservas_#{Time.current.to_i}.csv")
  end
end
