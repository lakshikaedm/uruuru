require 'rails_helper'
require "action_view"
include ActionView::Helpers::NumberHelper

RSpec.describe "Products UI", type: :system do
  let(:user) { create(:user) }

  it "lets a user sign in and create a product with an image" do
    sign_in user
    visit new_product_path

    fill_in "Title", with: "Camera"
    fill_in "Price", with: "1234.56"
    fill_in "Description", with: "Nice one"
    select "draft", from: "Status" rescue nil

    attach_file "Image", Rails.root.join("spec/fixtures/files/sample.jpg") rescue nil

    click_button "Create Product"

    expect(page).to have_content("Camera")
    expect(page).to have_content(number_to_currency(1234.56, unit: "¥", precision: 0))
    expect(page).to have_selector("img")

    product = Product.order(:created_at).last
    visit edit_product_path(product)
    fill_in "product_title", with: "Camera Pro"
    click_button "Update Product"
    expect(page).to have_content("Camera Pro")
  end
end
