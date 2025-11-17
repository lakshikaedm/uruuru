require "rails_helper"

RSpec.describe "Conversations", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "POST /conversations" do
    let!(:buyer)    { create(:user) }
    let!(:product)  { create(:product) }
    let!(:seller)   { product.user }

    context "when signed in" do
      before { sign_in buyer }

      it "creates a new conversation and redirects to it" do
        expect { post conversations_path, params: { participant_id: seller.id, product_id: product.id } }
          .to change(Conversation, :count).by(1)
        expect(response).to redirect_to(conversation_path(Conversation.last))
      end

      it "returns existing conversation without creating a new (idempotent)" do
        existing = Conversation.create!(product: product, buyer: buyer, seller: seller)
        existing.participants << [buyer, seller]

        expect { post conversations_path, params: { participant_id: seller.id, product_id: product.id } }
          .not_to change(Conversation, :count)
        expect(response).to redirect_to(conversation_path(existing))
      end

      it "rejects invalid params with 422 or re-render" do
        expect { post conversations_path, params: { participant_id: nil } }
          .not_to change(Conversation, :count)
        expect(response).to have_http_status(:unprocessable_content).or have_http_status(:ok)
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        post conversations_path, params: { participant_id: seller.id, product_id: product.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /conversations" do
    let!(:buyer)  { create(:user) }
    let!(:seller) { create(:user) }

    before do
      seller_product = create(:product, user: seller, title: "My Product")
      seller_conversation = Conversation.create!(
        product: seller_product,
        buyer: buyer,
        seller: seller
      )
      seller_conversation.participants << [buyer, seller]

      guest = create(:user)
      other_product = create(:product, user: guest, title: "Other's Product")
      other_conversation = Conversation.create!(
        product: other_product,
        buyer: buyer,
        seller: guest
      )
      other_conversation.participants << [buyer, guest]
    end

    context "when signed in" do
      before { sign_in seller }

      it "shows only my conversations" do
        get conversations_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("My Product")
        expect(response.body).not_to include("Other's Product")
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        get conversations_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /conversations/:id" do
    let!(:seller)       { create(:user) }
    let!(:buyer)        { create(:user) }
    let!(:product)      { create(:product, user: seller, title: "Detail Page Product") }
    let!(:conversation) do
      Conversation.create!(
        product: product,
        seller: seller,
        buyer: buyer
      )
    end

    before { conversation.participants << [seller, buyer] }

    context "when signed in" do
      before { sign_in seller }

      it "shows the conversation to a participant" do
        get conversation_path(conversation)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Detail Page Product")
      end

      it "returns 404 to a non-participant" do
        sign_out seller
        stranger = create(:user)
        sign_in stranger

        get conversation_path(conversation)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        get conversation_path(conversation)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
