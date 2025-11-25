#--Categories--
%w[Clothings Electronics Furniture Foods Cosmetics Books Uncategorized].each do |name|
  Category.find_or_create_by!(name: name)
end

# --- Categories (ancestry) ---
clothings = Category.find_or_create_by!(name: "Clothings")
tops     = clothings.children.find_or_create_by!(name: "Tops")
tees     = tops.children.find_or_create_by!(name: "T-Shirts")

#--Brands--
%w[Apple Samsung Sony Canon Nike Zara Adidas IKEA Wijaya MD Munchee Unbranded].each do |name|
  Brand.find_or_create_by!(name: name)
end

# --Recruiter demo user for interviews--
recruiter_email = ENV.fetch("RECRUITER_DEMO_EMAIL", "recruiter@example.com")

User.find_or_create_by!(email: recruiter_email) do |user|
  user.password = "recruiter-demo-password"
  user.password_confirmation = "recruiter-demo-password"
  user.name = "Recruiter Demo" if user.respond_to?(:name)
  user.username = "recruiter_demo"
end

#--Sample Data--
users_data = [
  # Japanese user 1
  {
    email: "taro@example.com",
    username: "taro-seller",
    password: "password123",
    products: [
      {
        title: "中古ソニーカメラ 良好な状態",
        description: "ストラップ付き・バッテリー良好。すぐに撮影できます。",
        price: 25000,
        category: "Electronics",
        brand: "Sony",
        status: :publish,
        image: "sony_camera.jpg"
      },
      {
        title: "NIKE パーカー メンズ L",
        description: "ワンシーズン使用。目立った汚れなし、まだまだ着られます。",
        price: 5000,
        category: "Clothings",
        brand: "Nike",
        status: :publish,
        image: "nike_hoodie.jpg"
      },
      {
        title: "ZARA スニーカー 27cm",
        description: "箱なし・多少使用感あり。普段履きにおすすめ",
        price: 3500,
        category: "Clothings",
        brand: "Zara",
        status: :publish,
        image: "zara_shoes.jpg"
      }
    ]
  },
  # Japanese user 2
  {
    email: "hanako@example.com",
    username: "hanako-seller",
    password: "password123",
    products: [
      {
        title: "Canon 単焦点レンズ 50mm",
        description: "ポートレートに最適。動作確認済み・カビなし。",
        price: 18000,
        category: "Electronics",
        brand: "Canon",
        status: :publish,
        image: "canon_lens.jpg"
      },
      {
        title: "Adidas ランニングキャップ",
        description: "数回使用のみ。洗濯済みで清潔な状態です。",
        price: 800,
        category: "Clothings",
        brand: "Adidas",
        status: :publish,
        image: "adidas_cap.jpg"
      },
      {
        title: "Nike Air Jordan 1",
        description: "コレクション整理のため出品。キズ・欠けなし",
        price: 25500,
        category: "Clothings",
        brand: "Nike",
        status: :publish,
        image: "nike_shoes.jpg"
      }
    ]
  },
  # English user 1
  {
    email: "alice@example.com",
    username: "alice-seller",
    password: "password123",
    products: [
      {
        title: "Apple AirPods Pro(2nd gen)",
        description: "Used for about 6 months, fully working, includes charging case.",
        price: 17000,
        category: "Electronics",
        brand: "Apple",
        status: :publish,
        image: "apple_airpods.png"
      },
      {
        title: "IKEA work lamp, dark gray",
        description: "Sturdy IKEA work lamp in dark gray. Provides bright, focused light—perfect for desks or bedside use. Used only a few times and kept in great condition.",
        price: 1800,
        category: "Furniture",
        brand: "IKEA",
        status: :publish,
        image: "ikea_tablelamp.jpg"
      },
      {
        title: "Samsung 24\" monitor",
        description: "Full HD, no dead pixels, HDMI cable included.",
        price: 15500,
        category: "Electronics",
        brand: "Samsung",
        status: :sold,
        image: "samsung_monitor.jpg"
      }
    ]
  },
  #English user 2
  {
    email: "david@example.com",
    username: "david-seller",
    password: "password123",
    products: [
      {
        title: "IKEA RASHULT: Wagon",
        description: "IKEA RÅSHULT rolling wagon. Sturdy, smooth-rolling, and perfect for extra storage. Gently used.",
        price: 1700,
        category: "Furniture",
        brand: "IKEA",
        status: :publish,
        image: "ikea_wagon.jpg"
      },
      {
        title: "Apple Magic Keyboard",
        description: "JIS layout, used for about a year.",
        price: 6000,
        category: "Electronics",
        brand: "Apple",
        status: :publish,
        image: "apple_keyboard.jpeg"
      },
      {
        title: "Ruby on Rails by  INDU PATLE",
        description: "‘Ruby on Rails’ by Indu Patle. Great for beginners learning Rails basics. Lightly used.",
        price: 1500,
        category: "Books",
        brand: "Unbranded",
        status: :publish,
        image: "ruby_on_rails.jpg"
      }
    ]
  },
  #Sinhala user 1
  {
    email: "chanuka@example.com",
    username: "chanuka-seller",
    password: "password123",
    products: [
      {
        title: "MD දිවුල් ජෑම්",
        description: "නවතම බෝතල්, පාන් එක්ක කන්න නියමයි. තොග වශයෙන් ඇත. ",
        price: 700,
        category: "Foods",
        brand: "MD",
        status: :publish,
        image: "md_jam.jpg"
      },
      {
        title: "Madol Doowa",
        description: "Roughly used, no stains, ask for a price change",
        price: 1200,
        category: "Books",
        brand: "Unbranded",
        status: :publish,
        image: "madol_doowa.jpg"
      },
      {
        title: "Wijaya Curry Powder 250g",
        description: "Wijaya Roasted Curry powders is produced using highest quality ingredients such as Coriander, Cumin seed and fennel seed as the major ingredients",
        price: 500,
        category: "Foods",
        brand: "Wijaya",
        status: :publish,
        image: "wijaya_curry.jpg"
      }
    ]
  },
  # Sinhala user 2
  {
    email: "buddika@example.com",
    username: "buddika-seller",
    password: "password123",
    products: [
      {
        title: "සූර්ය හෙළ කළු බතික් Sarong",
        description: "Sarongs are ideal for summer heat, beach or at home. This is a versatile garment that can be worn and used in many ways.",
        price: 3700,
        category: "Clothings",
        brand: "Unbranded",
        status: :sold,
        image: "sarong.jpeg"
      },
      {
        title: "Multivitamin Face Cream",
        description: "A unique blend of Vitamins B, C and E to nourish and invigorate your skin.",
        price: 2200,
        category: "Cosmetics",
        brand: "Unbranded",
        status: :publish,
        image: "nature_secret.png"
      },
      {
        title: "[ミカサ] バレーボール バレー練習球4号",
        description: "未使用、プレゼントとして受け取った、未開封",
        price: 2500,
        category: "Uncategorized",
        brand: "Unbranded",
        status: :publish,
        image: "volleyball.jpg"
      }
    ]
  }
]

users_data.each do |data|
  user = User.find_or_create_by!(email: data[:email]) do |u|
    u.username = data[:username]
    u.password = data[:password]
    u.password_confirmation = data[:password]
  end

  # Attach avatar if file exists and user has no avatar yet
  avatar_filename = "#{data[:username]}.jpg"
  avatar_path = Rails.root.join("db/seeds/images/#{avatar_filename}")

  if File.exist?(avatar_path) && !user.avatar.attached?
    avatar_content_type = Marcel::MimeType.for(avatar_path)

    user.avatar.attach(
      io: File.open(avatar_path),
      filename: avatar_filename,
      content_type: avatar_content_type
    )
  end

  data[:products].each do |p|
    category = Category.find_by!(name: p[:category])
    brand    = Brand.find_by!(name: p[:brand])

    product = Product.find_or_create_by!(title: p[:title], user: user) do |prod|
      prod.description = p[:description]
      prod.price       = p[:price]
      prod.status      = p[:status]
      prod.category    = category
      prod.brand       = brand
    end

    if p[:image].present?
      next if product.images.attached?

      path = Rails.root.join("db/seeds/images/#{p[:image]}")
      next unless File.exist?(path)

      content_type = Marcel::MimeType.for(path)

      product.images.attach(
        io: File.open(path),
        filename: p[:image],
        content_type: content_type
      )
    end
  end
end

# --- Seed favorites (likes) ---
users    = User.all
products = Product.all

users.each do |user|
  liked_products = products.where.not(user: user).sample(3)

  liked_products.each do |product|
    Favorite.find_or_create_by!(user: user, product: product)
  end
end

puts "Seeded #{Favorite.count} favorites."

puts "Seeded #{User.count} users and #{Product.count} products."
