require "rails_helper"

RSpec.describe "Cart flow", type: :system do
  let!(:product) { create(:product, price: 1500) }

  def add_to_cart(qty = 1)
    visit product_path(product)
    fill_in "cart_item[quantity]", with: qty
    click_on "Add to cart"
    expect(page).to have_current_path(cart_path)
  end

  describe "adding to cart" do
    it "adds a product with the given quantity" do
      add_to_cart(2)

      expect(page).to have_content(product.title)
      expect(page).to have_content("¥")
      expect(page).to have_field("cart_item[quantity]", with: "2")
    end
  end

  describe "updating cart item" do
    it "updates the quantity of an existing line item" do
      add_to_cart(2)

      within(:xpath, "//div[contains(@class,'divide-y')]") do
        fill_in "cart_item[quantity]", with: 3
        click_on "Update"
      end

      expect(page).to have_content("Subtotal")
      expect(page).to have_field("cart_item[quantity]", with: "3")
    end
  end

  describe "removing from cart" do
    it "removes the line item" do
      add_to_cart(1)

      click_on "Remove"
      expect(page).to have_content("Your cart is empty")
    end
  end
end
