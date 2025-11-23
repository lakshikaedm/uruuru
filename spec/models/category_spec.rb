require "rails_helper"

RSpec.describe Category, type: :model do
  describe ".top_for_homepage" do
    it "returns up to 6 categories ordered by product count desc then created_at desc" do
      older = create(:category, created_at: 2.days.ago)
      newer = create(:category, created_at: 1.day.ago)
      newest = create(:category, created_at: Time.current)

      create_list(:product, 3, category: newer)
      create_list(:product, 3, category: older)
      create_list(:product, 5, category: newest)

      result = described_class.top_for_homepage

      expect(result.first).to eq(newest)
      expect(result.to_a.size).to be <= 6
    end
  end
end
