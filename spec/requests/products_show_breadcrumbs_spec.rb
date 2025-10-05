require "rails_helper"

RSpec.describe "Products#show breadcrumbs", type: :request do
  it "shows Home -> category path -> product" do
    clothing = Category.create!(name: "Clothing")
    tees = clothing.children.create!(name: "T-Shirts")

    user = User.create!(
      email: "demo@example.com",
      username: "demo",
      password: "password"
    )

    product = Product.create!(
      title: "Demo Tee",
      price: 1000,
      status: :publish,
      user: user,
      category: tees
    )

    get product_path(product)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Home", "Clothing", "T-Shirts", "Demo Tee")
  end
end
