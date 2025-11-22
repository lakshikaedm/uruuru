require "rails_helper"

RSpec.describe "Orders", type: :request do
  let!(:user)    { create(:user) }
  let!(:product) { create(:product, price: 1200) }

  def seed_user_db_cart(user:, product:, qty: 1)
    cart = user.cart || user.create_cart!
    item = cart.cart_items.find_or_initialize_by(product: product)
    item.quantity = qty
    item.save!
  end

  describe "GET /orders/new" do
    it "redirects guest to login" do
      get new_order_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows form for authentic user" do
      sign_in user
      seed_user_db_cart(user: user, product: product, qty: 2)
      get new_order_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /orders" do
    let(:params) do
      {
        order: {
          shipping_name: "Yamada Taro",
          shipping_phone: "080-0000-0000",
          shipping_postal_code: "100-0001",
          shipping_prefecture: "Tokyo",
          shipping_city: "Shinjuku",
          shipping_address1: "1-1-1",
          shipping_address2: ""
        }
      }
    end

    before do
      sign_in user
      seed_user_db_cart(user: user, product: product, qty: 3)
      post orders_path, params: params
    end

    it "creates order" do
      expect(response).to redirect_to(order_path(Order.last))
    end

    it "moves items" do
      order = Order.last
      expect(order.user).to eq(user)
      expect(order.order_items.count).to eq(1)
    end

    it "calculate totals" do
      order = Order.last
      expect(order.subtotal_yen).to eq(1200 * 3)
      expect(order.total_yen).to eq(order.subtotal_yen + order.shipping_yen)
    end

    it "does not clear cart yet (cart is cleared on success)" do
      follow_redirect!
      expect(user.cart.reload.cart_items).not_to be_empty
    end
  end
end
