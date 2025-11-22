require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  let(:user) do
    create(:user, email: "buyer@example.com")
  end

  let(:order) do
    create(
      :order,
      user: user,
      subtotal_yen: 3000,
      shipping_yen: 500,
      total_yen: 3500
    )
  end

  describe "#confirmation" do
    subject(:mail) { described_class.confirmation(order) }

    it "sends to the buyer email" do
      expect(mail.to).to eq(["buyer@example.com"])
    end

    it "sets a localized subject" do
      expect(mail.subject).to include(order.id.to_s)
    end

    it "includes order total in the body" do
      expect(mail.body.encoded).to include("3500")
    end

    it "uses the given locale" do
      mail = I18n.with_locale(:ja) do
        described_class.with(locale: :ja).confirmation(order)
      end

      expect(mail.subject).to include("ご注文番号")
    end
  end
end
