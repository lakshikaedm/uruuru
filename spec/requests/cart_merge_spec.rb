require "rails_helper"

RSpec.describe "Cart merge on login", type: :request do
  let!(:user)    { create(:user, password: "password") }
  let!(:product) { create(:product, price: 1200) }

  it "merges session cart into DB cart after sign in" do
    post create_cart_item_path(product), params: { cart_item: { quantity: 2 } }
    expect(session[SessionCart::SESSION_KEY]).to be_present

    post user_session_path, params: { user: { email: user.email, password: "password" } }
    follow_redirect!

    expect(session[SessionCart::SESSION_KEY]).to eq({})
    expect(user.reload.cart.cart_items.find_by(product_id: product.id).quantity).to eq(2)
  end
end
