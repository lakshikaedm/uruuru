require "rails_helper"

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before { sign_in user }

  it "adds a product to favorites" do
    post product_favorite_path(product)

    expect(Favorite.exists?(user:, product:)).to be true
    expect(product.reload.favorites_count).to eq 1
  end

  it "removes a product from favorites" do
    create(:favorite, user:, product:)

    delete product_favorite_path(product)

    expect(Favorite.exists?(user:, product:)).to be false
    expect(product.reload.favorites_count).to eq 0
  end
end
