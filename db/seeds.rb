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
  user = User.find_or_create_by!(email_address: "admin@example.com") do |u|
    u.name = "Admin"
    u.password = "password"
  end

  grand_canyon = Tour.find_or_create_by!(name: "Grand Canyon Adventure") do |t|
    t.description = "A breathtaking journey through the Grand Canyon with expert guides. Includes hiking, photography stops, and a sunset picnic."
    t.base_price = 199.99
  end

  wine_country = Tour.find_or_create_by!(name: "Napa Valley Wine Tour") do |t|
    t.description = "Explore the finest vineyards in Napa Valley. Includes tastings at 5 wineries, a gourmet lunch, and behind-the-scenes cellar tours."
    t.base_price = 249.99
  end

  coast_highway = Tour.find_or_create_by!(name: "Pacific Coast Highway") do |t|
    t.description = "A scenic drive along California's iconic coastline. Stops at Big Sur, Monterey Bay Aquarium, and Hearst Castle."
    t.base_price = 179.99
  end

  nyc_food = Tour.find_or_create_by!(name: "NYC Food Crawl") do |t|
    t.description = "Taste your way through New York City's best neighbourhoods. Pizza in Brooklyn, bagels in Manhattan, and dumplings in Chinatown."
    t.base_price = 129.99
  end

  hiking_add_ons = [
    { name: "Private Guide", price: 49.99, status: :available },
    { name: "Lunch Package", price: 24.99, status: :available },
    { name: "Photography Workshop", price: 39.99, status: :available },
    { name: "Souvenir Photo Book", price: 19.99, status: :available }
  ]

  wine_add_ons = [
    { name: "Wine Shipping (6 bottles)", price: 59.99, status: :available },
    { name: "Caviar Pairing", price: 44.99, status: :available },
    { name: "Private Limo Upgrade", price: 89.99, status: :available },
    { name: "Cheese Board Add-on", price: 29.99, status: :available }
  ]

  coast_add_ons = [
    { name: "Hotel Upgrade (Ocean View)", price: 79.99, status: :available },
    { name: "Camera Drone Footage", price: 34.99, status: :available },
    { name: "Seafood Lunch Stop", price: 39.99, status: :available },
    { name: "Sunset Cruise Add-on", price: 54.99, status: :available }
  ]

  food_add_ons = [
    { name: "Dessert Tasting Flight", price: 19.99, status: :available },
    { name: "Cocktail Pairing", price: 34.99, status: :available },
    { name: "Recipe Book", price: 14.99, status: :available },
    { name: "VIP Seating Upgrade", price: 29.99, status: :available }
  ]

  tour_add_ons = {
    grand_canyon => hiking_add_ons,
    wine_country => wine_add_ons,
    coast_highway => coast_add_ons,
    nyc_food => food_add_ons
  }

  tour_add_ons.each do |tour, add_ons|
    add_ons.each do |attrs|
      tour.add_ons.find_or_create_by!(name: attrs[:name]) do |a|
        a.price = attrs[:price]
        a.status = attrs[:status]
      end
    end
  end
end
