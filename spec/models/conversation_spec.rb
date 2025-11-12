require "rails_helper"

RSpec.describe Conversation, type: :model do
  describe "associations" do
    it { is_expected.to respond_to(:product) }
    it { is_expected.to respond_to(:buyer) }
    it { is_expected.to respond_to(:seller) }
    it { is_expected.to respond_to(:messages) }
  end

  describe "validations" do
    subject(:conversation) { build(:conversation) }

    it "is valid with product, buyer, seller" do
      expect(conversation).to be_valid
    end

    it "is invalid without product" do
      conversation.product = nil
      expect(conversation).to be_invalid
      expect(conversation.errors[:product]).to be_present
    end

    it "is invalid without buyer" do
      conversation.buyer = nil
      expect(conversation).to be_invalid
      expect(conversation.errors[:buyer]).to be_present
    end

    it "is invalid without seller" do
      conversation.seller = nil
      expect(conversation).to be_invalid
      expect(conversation.errors[:seller]).to be_present
    end

    it "enforces uniqueness of [product_id, buyer_id, seller_id]" do
      existing = create(:conversation)
      dup = build(
        :conversation,
        product: existing.product,
        buyer: existing.buyer,
        seller: existing.seller
      )
      expect(dup).to be_invalid
      expect(dup.errors[:product_id]).to include(a_string_matching(/taken|既に/i))
    end
  end

  describe "scoping / helpers" do
    it "only lists conversations the user participates in" do
      me        = create(:user)
      other     = create(:user)
      product1 = create(:product)
      product2 = create(:product)

      mine_as_buyer   = create(:conversation, product: product1, buyer: me, seller: other)
      mine_as_seller  = create(:conversation, product: product2, buyer: other, seller: me)
      not_mine        = create(:conversation)

      expect(described_class.for_user(me)).to contain_exactly(mine_as_buyer, mine_as_seller)
      expect(described_class.for_user(me)).not_to include(not_mine)
    end
  end
end
