require "rails_helper"

RSpec.describe "Shipping checkout", type: :system do
  let!(:user)     { create(:user) }
  let!(:product)  { create(:product, price: 1500) }

  before do
    sign_in user
    cart = user.cart || user.create_cart!
    cart.cart_items.create!(product: product, quantity: 1)
  end

  def place_order
    visit new_order_path

    fill_in "Full name", with: "Yamada Taro"
    fill_in "Phone", with: "080-0000-1111"
    fill_in "Postal code", with: "101-1001"
    select "Tokyo", from: "Prefecture"
    fill_in "City", with: "Shibuya"
    fill_in "Address line 1", with: "1-2-3"

    click_button "Place order"
  end

  it "places an order successfully" do
    place_order

    expect(page).to have_content("Order")
    expect(page).to have_content(product.title)
  end

  it "shows shipping fee and totals" do
    place_order

    expect(page).to have_css("#item-quantity", text: "x 1", count: 1)
    expect(page).to have_content("Shipping ¥500")
    expect(page).to have_content("¥2,000")
  end
end
