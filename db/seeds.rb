# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if Rails.env.development?

  # ── Users ───────────────────────────────────────────────────────
  admin = User.find_or_create_by!(email_address: "admin@example.com") do |u|
    u.name = "Admin"
    u.password = "password"
  end

  customers = [
    { name: "Alice Morgan",   email: "alice@example.com" },
    { name: "Ben Nakamura",   email: "ben@example.com" },
    { name: "Clara Voss",     email: "clara@example.com" },
    { name: "Diego Herrera",  email: "diego@example.com" }
  ].map do |attrs|
    User.find_or_create_by!(email_address: attrs[:email]) do |u|
      u.name     = attrs[:name]
      u.password = "password"
    end
  end

  # ── Tours ────────────────────────────────────────────────────────
  tours_data = [
    {
      name: "Grand Canyon Adventure",
      description: "A breathtaking journey through the Grand Canyon with expert guides. Includes hiking, photography stops, and a sunset picnic.",
      base_price: 199.99,
      add_ons: [
        { name: "Private Guide",          price: 49.99 },
        { name: "Lunch Package",          price: 24.99 },
        { name: "Photography Workshop",   price: 39.99 },
        { name: "Souvenir Photo Book",    price: 19.99, active: false }
      ]
    },
    {
      name: "Napa Valley Wine Tour",
      description: "Explore the finest vineyards in Napa Valley. Includes tastings at 5 wineries, a gourmet lunch, and behind-the-scenes cellar tours.",
      base_price: 249.99,
      add_ons: [
        { name: "Wine Shipping (6 bottles)", price: 59.99 },
        { name: "Caviar Pairing",            price: 44.99 },
        { name: "Private Limo Upgrade",      price: 89.99 },
        { name: "Cheese Board Add-on",       price: 29.99 }
      ]
    },
    {
      name: "Pacific Coast Highway",
      description: "A scenic drive along California's iconic coastline. Stops at Big Sur, Monterey Bay Aquarium, and Hearst Castle.",
      base_price: 179.99,
      add_ons: [
        { name: "Hotel Upgrade (Ocean View)", price: 79.99 },
        { name: "Camera Drone Footage",       price: 34.99 },
        { name: "Seafood Lunch Stop",         price: 39.99 },
        { name: "Sunset Cruise Add-on",       price: 54.99, active: false }
      ]
    },
    {
      name: "NYC Food Crawl",
      description: "Taste your way through New York City's best neighbourhoods. Pizza in Brooklyn, bagels in Manhattan, and dumplings in Chinatown.",
      base_price: 129.99,
      add_ons: [
        { name: "Dessert Tasting Flight", price: 19.99 },
        { name: "Cocktail Pairing",       price: 34.99 },
        { name: "Recipe Book",            price: 14.99 },
        { name: "VIP Seating Upgrade",    price: 29.99 }
      ]
    }
  ]

  tours = tours_data.map do |data|
    tour = Tour.find_or_create_by!(name: data[:name]) do |t|
      t.description = data[:description]
      t.base_price  = data[:base_price]
    end

    data[:add_ons].each do |attrs|
      tour.add_ons.find_or_create_by!(name: attrs[:name]) do |a|
        a.price  = attrs[:price]
        a.active = attrs.fetch(:active, true)
      end
    end

    tour
  end

  # ── Bookings ─────────────────────────────────────────────────────
  booking_templates = [
    { user: customers[0], tour: tours[0], status: :confirmed,  num_guests: 2, days_from_now: 14,  note: "Vegetarian meals please." },
    { user: customers[0], tour: tours[2], status: :pending,    num_guests: 1, days_from_now: 30,  note: nil },
    { user: customers[1], tour: tours[1], status: :confirmed,  num_guests: 4, days_from_now: 7,   note: "Anniversary trip." },
    { user: customers[1], tour: tours[3], status: :cancelled,  num_guests: 2, days_from_now: -5,  note: "Had to cancel, work conflict." },
    { user: customers[2], tour: tours[0], status: :confirmed,  num_guests: 3, days_from_now: 21,  note: nil },
    { user: customers[2], tour: tours[1], status: :pending,    num_guests: 2, days_from_now: 45,  note: "First time wine tour!" },
    { user: customers[3], tour: tours[3], status: :confirmed,  num_guests: 5, days_from_now: 10,  note: "Group birthday celebration." },
    { user: customers[3], tour: tours[2], status: :cancelled,  num_guests: 1, days_from_now: -10, note: nil }
  ]

  booking_templates.each do |b|
    tour_date   = Time.current + b[:days_from_now].days
    total_price = b[:tour].base_price * b[:num_guests]

    Booking.find_or_create_by!(user: b[:user], tour: b[:tour], tour_date: tour_date.to_date) do |booking|
      booking.status      = b[:status]
      booking.num_guests  = b[:num_guests]
      booking.total_price = total_price
      booking.note        = b[:note]
    end
  end

  puts "Seeded: #{User.count} users, #{Tour.count} tours, #{AddOn.count} add-ons, #{Booking.count} bookings"
end
