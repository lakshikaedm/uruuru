require "rails_helper"

RSpec.describe FavoritesHelper, type: :helper do
  it "returns true if user liked a product" do
    user = create(:user)
    product = create(:product)
    sign_in user
    create(:favorite, user:, product:)

    expect(helper.favorited?(product)).to be true
  end
end
