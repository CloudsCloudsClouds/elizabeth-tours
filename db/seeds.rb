if Rails.env.development?

  # ── Users ───────────────────────────────────────────────────────
  admin = User.find_or_create_by!(email_address: "admin@example.com") do |u|
    u.name = "Admin"
    u.password = "password"
    u.role = 1
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
      u.role = 0
    end
  end

  # ── Tours ────────────────────────────────────────────────────────
  tours_data = [
    {
      name:        "Lake Titicaca",
      name_es:     "Lago Titicaca",
      description: "Explore the highest navigable lake in the world. Visit Copacabana, Isla del Sol, and the floating Uros islands. Includes a traditional boat ride and lunch with local families.",
      description_es: "Explora el lago navegable más alto del mundo. Visita Copacabana, la Isla del Sol y las islas flotantes Uros. Incluye paseo en bote tradicional y almuerzo con familias locales.",
      base_price:  149.99,
      add_ons: [
        { name: "T-shirt",           name_es: "Camiseta",        price: 19.99 },
        { name: "Lunch",             name_es: "Almuerzo",        price: 14.99 },
        { name: "Souvenir photo",    name_es: "Foto recuerdo",   price: 9.99 },
        { name: "Guide",             name_es: "Guía",            price: 29.99 }
      ]
    },
    {
      name:        "Illimani",
      name_es:     "Illimani",
      description: "Conquer the highest peak of the Cordillera Real overlooking La Paz. A challenging two-day trek with professional guides, camping gear, and breathtaking panoramic views.",
      description_es: "Conquista la cumbre más alta de la Cordillera Real con vista a La Paz. Una caminata desafiante de dos días con guías profesionales, equipo de campamento y vistas panorámicas impresionantes.",
      base_price:  299.99,
      add_ons: [
        { name: "T-shirt",           name_es: "Camiseta",         price: 24.99 },
        { name: "Breakfast",         name_es: "Desayuno",         price: 9.99 },
        { name: "Transport",         name_es: "Transporte",       price: 39.99 },
        { name: "Trekking poles",    name_es: "Bastones de trekking", price: 14.99, active: false }
      ]
    },
    {
      name:        "Sajama",
      name_es:     "Sajama",
      description: "Ascend Bolivia's highest volcano at 6,542 meters. Traverse the stunning altiplano with its native wildlife, hot springs, and giant cacti forests before reaching the snowy summit.",
      description_es: "Asciende el volcán más alto de Bolivia a 6,542 metros. Atraviesa el impresionante altiplano con su fauna nativa, aguas termales y bosques de cactus gigantes antes de llegar a la cumbre nevada.",
      base_price:  399.99,
      add_ons: [
        { name: "T-shirt",           name_es: "Camiseta",         price: 24.99 },
        { name: "Lunch",             name_es: "Almuerzo",         price: 14.99 },
        { name: "Guide",             name_es: "Guía",             price: 49.99 },
        { name: "Transport",         name_es: "Transporte",       price: 44.99 }
      ]
    },
    {
      name:        "Death Road Cycling",
      name_es:     "Ciclismo Camino de la Muerte",
      description: "Ride the world-famous Yungas Road from La Cumbre to Coroico. A thrilling 64 km downhill descent through cloud forests, waterfalls, and dramatic cliffs. Bike and safety gear included.",
      description_es: "Recorre la mundialmente famosa Carretera de los Yungas desde La Cumbre hasta Coroico. Una emocionante bajada de 64 km a través de bosques nublados, cascadas y acantilados. Bicicleta y equipo de seguridad incluidos.",
      base_price:  89.99,
      add_ons: [
        { name: "T-shirt",           name_es: "Camiseta",         price: 19.99 },
        { name: "Lunch",             name_es: "Almuerzo",         price: 12.99 },
        { name: "Souvenir photo",    name_es: "Foto recuerdo",    price: 9.99 },
        { name: "Breakfast",         name_es: "Desayuno",         price: 7.99,  active: false }
      ]
    }
  ]

  tours = tours_data.map do |data|
    tour = Tour.find_or_create_by!(name: data[:name]) do |t|
      t.name_translations           = { "es" => data[:name_es] }
      t.description                 = data[:description]
      t.description_translations    = { "es" => data[:description_es] }
      t.base_price                  = data[:base_price]
    end

    # Update translations if tour already existed without them
    if tour.name_translations.blank? || tour.name_translations["es"].blank?
      tour.update!(name_translations: { "es" => data[:name_es] })
    end
    if tour.description_translations.blank? || tour.description_translations["es"].blank?
      tour.update!(description_translations: { "es" => data[:description_es] })
    end

    data[:add_ons].each do |attrs|
      tour.add_ons.find_or_create_by!(name: attrs[:name]) do |a|
        a.name_translations = { "es" => attrs[:name_es] }
        a.price             = attrs[:price]
        a.active            = attrs.fetch(:active, true)
      end
    end

    tour
  end

  # ── Bookings ─────────────────────────────────────────────────────
  booking_templates = [
    { user: customers[0], tour: tours[0], status: :confirmed,  num_guests: 2, days_from_now: 14,  note: "Vegetarian lunch please." },
    { user: customers[0], tour: tours[2], status: :pending,    num_guests: 1, days_from_now: 30,  note: nil },
    { user: customers[1], tour: tours[1], status: :confirmed,  num_guests: 4, days_from_now: 7,   note: "Need extra camping gear." },
    { user: customers[1], tour: tours[3], status: :cancelled,  num_guests: 2, days_from_now: -5,  note: "Afraid of heights!" },
    { user: customers[2], tour: tours[0], status: :confirmed,  num_guests: 3, days_from_now: 21,  note: "Window seat on boat please." },
    { user: customers[2], tour: tours[1], status: :pending,    num_guests: 2, days_from_now: 45,  note: "First time climbing at altitude." },
    { user: customers[3], tour: tours[3], status: :confirmed,  num_guests: 5, days_from_now: 10,  note: "Group from hostel." },
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
