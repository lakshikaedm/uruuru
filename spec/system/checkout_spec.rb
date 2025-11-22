require "rails_helper"

RSpec.describe "Checkout", type: :system do
  let!(:user)     { create(:user) }
  let!(:product)  { create(:product, price: 1500) }

  def seed_user_db_cart(user:, product:, qty: 1)
    cart = user.cart || user.create_cart!
    item = cart.cart_items.find_or_initialize_by(product: product)
    item.quantity = qty
    item.save!
  end

  before do
    fake_session = instance_double(
      Stripe::Checkout::Session,
      url: "https://stripe.test/checkout"
    )

    allow(Stripe::Checkout::Session)
      .to receive(:create)
      .and_return(fake_session)
  end

  it "blocks guest" do
    visit new_order_path
    expect(page).to have_current_path(new_user_session_path)
  end

  it "allows user to checkout and shows order" do
    sign_in user
    seed_user_db_cart(user: user, product: product, qty: 2)

    visit new_order_path
    fill_in "Full name", with: "Yamada Taro"
    fill_in "Phone", with: "080-0000-1111"
    fill_in "Postal code", with: "101-1001"
    select "Tokyo", from: "Prefecture"
    fill_in "City", with: "Shibuya"
    fill_in "Address line 1", with: "1-2-3"
    click_button "Proceed to Payment"

    expect(page).to have_content("Order")
    expect(page).to have_content(product.title)
  end

  it "shows correct totals and clears cart" do
    sign_in user
    seed_user_db_cart(user: user, product: product, qty: 2)

    visit new_order_path
    fill_in "Full name", with: "Yamada Taro"
    fill_in "Phone", with: "080-0000-1111"
    fill_in "Postal code", with: "101-1001"
    select "Tokyo", from: "Prefecture"
    fill_in "City", with: "Shibuya"
    fill_in "Address line 1", with: "1-2-3"
    click_button "Proceed to Payment"

    expect(page).to have_content("¥3,000")

    order = Order.last
    visit success_order_path(order)

    expect(user.cart.reload.cart_items).to be_empty
  end
end
