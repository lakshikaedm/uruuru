require 'rails_helper'

RSpec.describe ProductPolicy do
  subject(:policy) { described_class }

  let(:owner) { create(:user) }
  let(:other) { create(:user) }
  let(:product) { create(:product, user: owner) }

  permissions :create? do
    it "allows logged in users" do
      expect(policy).to permit(owner, Product.new)
    end

    it "denies guests" do
      expect(policy).not_to permit(nil, Product.new)
    end
  end

  permissions :update?, :destroy? do
    it "allows owner" do
      expect(policy).to permit(owner, product)
    end

    it "denies other users" do
      expect(policy).not_to permit(other, product)
    end
  end

  permissions :show?, :index? do
    it "allows anyone" do
      expect(policy).to permit(nil, product)
    end
  end
end
