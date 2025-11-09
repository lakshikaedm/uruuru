require "rails_helper"

RSpec.describe "CartItems", type: :request do
  let!(:product) { create(:product, price: 2200) }

  it "adds items" do
    post create_cart_item_path(product), params: { cart_item: { quantity: 1 } }
    expect(response).to redirect_to(cart_path)
    follow_redirect!
    expect(response.body).to include(product.title)
    expect(response.body).to include("1")
  end

  it "updates items" do
    patch update_cart_item_path(product), params: { cart_item: { quantity: 3 } }
    expect(response).to redirect_to(cart_path)
    follow_redirect!
    expect(response.body).to include("Subtotal")
    expect(response.body).to include("3")
  end

  it "removes items" do
    delete destroy_cart_item_path(product)
    expect(response).to redirect_to(cart_path)
    follow_redirect!
    expect(response.body).to include("Your cart is empty")
  end
end
