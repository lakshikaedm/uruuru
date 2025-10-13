require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it "updates product favorite count" do
    user = create(:user)
    product = create(:product)

    Favorite.create!(user:, product:)
    expect(product.reload.favorites_count).to eq 1

    Favorite.find_by(user:, product:).destroy
    expect(product.reload.favorites_count).to eq 0
  end
end
