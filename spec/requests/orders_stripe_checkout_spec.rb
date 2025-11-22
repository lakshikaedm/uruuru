require "rails_helper"

RSpec.describe "Stripe checkout", type: :request do
  let(:user) { create(:user) }
  let!(:product) { create(:product, price: 3000) }

  before do
    sign_in user

    post create_cart_item_path(product.id)
  end

  it "redirects to Stripe checkout" do
    fake_session = instance_double(
      Stripe::Checkout::Session,
      url: "https://stripe.test/checkout"
    )

    allow(Stripe::Checkout::Session)
      .to receive(:create)
      .and_return(fake_session)

    post orders_path, params: {
      order: {
        shipping_name: "Test User",
        shipping_postal_code: "123-4567",
        shipping_prefecture: "Tokyo",
        shipping_city: "Shibuya",
        shipping_address1: "Tokyo",
        shipping_address2: "",
        shipping_phone: "09000000000"
      }
    }

    order = Order.last
    expect(order).not_to be_nil

    post pay_order_path(order)

    expect(response).to have_http_status(:found)
    expect(response).to redirect_to("https://stripe.test/checkout")
  end
end
