require "rails_helper"

RSpec.describe "categories", type: :request do
  context "when showing a category" do
    let(:category) { Category.create!(name: "Cameras") }
    let(:other)    { Category.create!(name: "Shoes") }
    let(:user) { User.create!(email: "test@example.com", password: "password123", username: "tester") }

    before do
      Product.create!(title: "Sony a7",  price: 120_000, category: category, user: user)
      Product.create!(title: "Nikon Z5", price:  90_000, category: category, user: user)
      Product.create!(title: "Air Max",  price:  12_000, category: other,    user: user)
      get category_path(category.id)
    end

    it "responds 200 OK" do
      expect(response).to have_http_status(:ok)
    end

    it "renders HTML" do
      expect(response.media_type).to eq("text/html")
    end

    it "shows only products in the category" do
      expect(response.body).to include("Sony a7", "Nikon Z5")
      expect(response.body).not_to include("Air Max")
    end

    it "shows the category name" do
      expect(response.body).to include("Cameras")
    end
  end

  context "when category is missing" do
    it "returns 404 for missing category" do
      get category_path(999_999)
      expect(response).to have_http_status(:not_found)
    end
  end
end
