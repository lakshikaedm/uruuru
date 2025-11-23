require "rails_helper"

RSpec.describe Brand, type: :model do
  describe ".top_for_homepage" do
    it "returns up to 6 brands ordered by product count desc then created_at desc" do
      older = create(:brand, created_at: 2.days.ago)
      newer = create(:brand, created_at: 1.day.ago)
      newest = create(:brand, created_at: Time.current)

      create_list(:product, 3, brand: newer)
      create_list(:product, 3, brand: older)
      create_list(:product, 5, brand: newest)

      result = described_class.top_for_homepage

      expect(result.first).to eq(newest)
      expect(result.to_a.size).to be <= 6
    end
  end
end
