%w[Clothing Caps Bags Mugs Electronics].each do |name|
  Category.find_or_create_by!(name: name)
end

# db/seeds.rb

# --- Categories (ancestry) ---
clothing = Category.find_or_create_by!(name: "Clothing")
tops     = clothing.children.find_or_create_by!(name: "Tops")
tees     = tops.children.find_or_create_by!(name: "T-Shirts")

user = User.find_or_initialize_by(email: "demo@example.com")
user.username ||= "demo"
user.password ||= "password"
user.save!

product = Product.find_or_initialize_by(title: "Demo Tee", user: user)
product.assign_attributes(
  price:    1000,
  status:   :publish,
  category: tees
)
product.save!
