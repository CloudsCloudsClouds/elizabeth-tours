module Admin
  class ReportsController < Admin::ApplicationController
    def index
      @revenue_over_time = Booking.where(status: :confirmed)
                                  .group_by_month(:tour_date, last: 12, format: "%b %Y")
                                  .sum(:total_price)

      @revenue_by_tour = Booking.where(status: :confirmed)
                                .joins(:tour)
                                .group("tours.name")
                                .sum(:total_price)

      @revenue_by_status = Booking.group(:status).sum(:total_price)

      @upcoming_bookings = Booking.where("tour_date >= ?", Date.current)
                                   .where.not(status: :cancelled)
                                   .order(:tour_date)
                                   .includes(:tour, :user)
                                   .limit(50)

      @avg_group_size = Booking.where(status: [ :pending, :confirmed ])
                                .joins(:tour)
                                .group("tours.name")
                                .average(:num_guests)

      @bookings_by_dow = Booking.where(status: [ :pending, :confirmed ])
                                 .group_by_day_of_week(:tour_date, format: "%A")
                                 .count
                                 .sort_by { |day, _| Date::DAYNAMES.index(day) || 0 }

      respond_to do |format|
        format.html
        format.pdf { render pdf: "reports", layout: "admin/reports" }
      end
    end
  end
end
