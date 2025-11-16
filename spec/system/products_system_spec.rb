require "rails_helper"
require "action_view"
include ActionView::Helpers::NumberHelper

RSpec.describe "Products UI", type: :system do
  let(:user)     { create(:user) }
  let(:category) { create(:category, name: "Cameras") }

  it "creates a product with an image" do
    sign_in user
    category
    visit new_product_path

    fill_in "Title",       with: "Camera"
    fill_in "Price",       with: "1234.56"
    fill_in "Description", with: "Nice one"
    select  "Cameras",     from: "Category"

    # Label in form is "Images", so use that
    attach_file "Images", Rails.root.join("spec/fixtures/files/sample.jpg")

    # Button text in the form is "Save Product"
    click_button "Save Product"

    expect(page).to have_content("Camera")
    expect(page).to have_content(number_to_currency(1234.56, unit: "¥", precision: 0))
    expect(page).to have_css("img")
  end

  it "edits an existing product title" do
    product = create(:product, user: user, title: "Camera", price: 1234.56)

    sign_in user
    visit edit_product_path(product)

    fill_in "product_title", with: "Camera Pro"

    # Same shared form, same button text
    click_button "Save Product"

    expect(page).to have_content("Camera Pro")
  end
end
