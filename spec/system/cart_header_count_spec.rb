require "rails_helper"

RSpec.describe "Cart header count", type: :system do
  let!(:user)    { create(:user, password: "password") }
  let!(:product) { create(:product, price: 1500) }

  it "shows count for guest and persists after login" do
    visit product_path(product)
    fill_in "cart_item[quantity]", with: 2
    click_on "Add to cart"

    expect(page).to have_text(/Cart\s*2/)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_text(/Cart\s*2/)
  end

  it "updates header count after qty change in cart page" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    visit product_path(product)
    fill_in "cart_item[quantity]", with: 2
    click_on "Add to cart"

    visit cart_path
    fill_in "cart_item[quantity]", with: 3
    click_on "Update"

    expect(page).to have_content("Subtotal")
    expect(page).to have_content("3")
  end
end
