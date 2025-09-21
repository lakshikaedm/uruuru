require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:owner) { create(:user) }
  let!(:product) { create(:product, user: owner) }

  describe "GET/products" do
    it "works for guest" do
      get products_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET/products/new" do
    it "requires login" do
      get new_product_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST/products" do
    it "creates with login" do
      sign_in owner
      expect {
        post products_path, params: { product: { title: "New", price: 100, status: :draft } }
      }.to change(Product, :count).by(1)
      expect(response).to redirect_to(product_path(Product.last))
    end
  end
  
  describe "PATCH/products/:id" do
    it "prevents non-owner" do
      sign_in create(:user)
      patch product_path(product), params: { product: { title: "Hacked" } }
      expect(response).to have_http_status(:redirect)
      expect(product.reload.title).not_to eq("Hacked")
    end
  end

  describe "DELETE/products/:id" do
    it "allows owner" do
      sign_in owner
      expect {
        delete product_path(product)
      }.to change(Product, :count).by(-1)
    end
  end
end
