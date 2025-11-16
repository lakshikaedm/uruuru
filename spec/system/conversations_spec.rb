require "rails_helper"

RSpec.describe "Conversations", type: :system do
  let!(:seller)   { create(:user, email: "seller@example.com") }
  let!(:buyer)    { create(:user, email: "buyer@example.com") }
  let!(:product)  { create(:product, user: seller, title: "Cool Item") }

  context "when signed in" do
    it "buyer starts a conversation from product page and sends a message" do
      sign_in buyer
      visit product_path(product)
      click_on "Ask the seller"

      expect(page).to have_current_path(conversation_path(Conversation.last))
      expect(page).to have_content("Cool Item")

      fill_in "message_body", with: "Hi, is this available?"
      click_on "Send"

      expect(page).to have_content("Hi, is this available?")
    end

    it "shows existing messages in a conversation" do
      conversation = Conversation.create!(product:, buyer:, seller:)
      conversation.messages.create!(user: buyer, body: "First message")
      conversation.messages.create!(user: seller, body: "Reply message")

      sign_in buyer
      visit conversation_path(conversation)

      expect(page).to have_content("First Message")
      expect(page).to have_content("Reply Message")
    end
  end

  context "when viewing as a guest" do
    it "does not show the chat button and prompt sign-in" do
      visit product_path(product)

      expect(page).to have_content(product.title)
      expect(page).to have_no_button("Ask the seller")
      expect(page).to have_content("Sign in to ask the seller a question.")
    end
  end
end
