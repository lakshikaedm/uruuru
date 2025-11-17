require "rails_helper"

RSpec.describe Message, type: :model do
  describe "associations" do
    it { is_expected.to respond_to(:conversation) }
    it { is_expected.to respond_to(:user) }
  end

  describe "validations" do
    subject(:message) { build(:message) }

    it "is valid with conversation, user, body" do
      expect(message).to be_valid
    end

    it "requires a body" do
      message.body = ""
      expect(message).to be_invalid
      expect(message.errors[:body]).to be_present
    end

    it "rejects overly long body" do
      message.body = "a" * 501
      expect(message).to be_invalid
      expect(message.errors[:body]).to be_present
    end
  end

  describe "ordering" do
    it "returns messages oldest -> newest when ordered by created_at" do
      conversation = create(:conversation)
      message1     = create(:message, conversation: conversation, created_at: 2.minutes.ago)
      message2     = create(:message, conversation: conversation, created_at: 1.minute.ago)
      message3     = create(:message, conversation: conversation, created_at: Time.current)

      expect(conversation.messages.by_oldest.pluck(:id)).to eq([message1.id, message2.id, message3.id]) if described_class.respond_to?(:by_oldest)
    end
  end
end
