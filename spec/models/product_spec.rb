require 'rails_helper'

RSpec.describe Product, type: :model do
  it "is valid with minimal fields" do
    expect(build(:product)).to be_valid
  end

  it "requires a title" do
    product = build(:product, title: nil)
    expect(product).to be_invalid
    expect(product.errors[:title]).to include("can't be blank")
  end

  it "requires non-negative price" do
    product = build(:product, price: -1)
    expect(product).to be_invalid
    expect(product.errors[:price]).to be_present
  end

  it "has expected statuses mapping" do
    expect(described_class.statuses).to eq({ "draft" => 0, "publish" => 1, "sold" => 2 })
  end
end
