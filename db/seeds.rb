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
  price: 1000,
  status: :publish,
  category: tees
)
product.save!

# Recruiter demo user for interviews
recruiter_email = ENV.fetch("RECRUITER_DEMO_EMAIL", "recruiter@example.com")

User.find_or_create_by!(email: recruiter_email) do |user|
  user.password = "recruiter-demo-password"
  user.password_confirmation = "recruiter-demo-password"
  user.name = "Recruiter Demo" if user.respond_to?(:name)
  user.username = "recruiter_demo"
end
