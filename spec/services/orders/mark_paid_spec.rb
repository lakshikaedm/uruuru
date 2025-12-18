require "rails_helper"

RSpec.describe Orders::MarkPaid do
  describe "#call" do
    it "marks order as paid and products as sold in one transaction" do
      user    = create(:user)
      product = create(:product, status: :publish)
      order   = create(:order, user:, status: :pending)
      create(:order_item, order:, product:)

      described_class.new(order:).call

      expect(order.reload).to be_paid
      expect(product.reload).to be_sold
    end

    it "is idempotent when order is already paid" do
      user    = create(:user)
      product = create(:product, status: :sold)
      order   = create(:order, user:, status: :paid)
      create(:order_item, order:, product:)

      expect { described_class.new(order:).call }.not_to raise_error
      expect(order.reload).to be_paid
      expect(product.reload).to be_sold
    end

    it "raises error when any product is already sold for a pending order" do
      user    = create(:user)
      product = create(:product, status: :sold)
      order   = create(:order, user:, status: :pending)
      create(:order_item, order:, product:)

      expect do
        described_class.new(order:).call
      end.to raise_error(Orders::MarkPaid::ProductAlreadySoldError)
    end
  end
end
