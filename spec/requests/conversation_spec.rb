require "rails_helper"

RSpec.describe "Conversations", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "POST /conversations" do
    let!(:me)       { create(:user) }
    let!(:other)    { create(:user) }
    let!(:product)  { create(:product) }

    context "when signed in" do
      before { sign_in me }

      it "creates a new conversation and redirects to it" do
        expect { post conversations_path, params: { participant_id: other.id, product_id: product.id } }
          .to change(Conversation, :count).by(1)
        expect(response).to redirect_to(conversation_path(Conversation.last))
      end

      it "returns existing conversation without creating a new (idempotent)" do
        existing = Conversation.create!(product: product)
        existing.participants << [me, other]

        expect { post conversations_path, params: { participant_id: other.id, product_id: product.id } }
          .not_to change(Conversation, :count)
        expect(response).to redirect_to(conversation_path(existing))
      end

      it "rejects invalid params with 422 or re-render" do
        expect { post conversations_path, params: { participant_id: nil } }
          .not_to change(Conversation, :count)
        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        post conversations_path, params: { participant_id: other.id, product_id: product.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /conversations" do
    let!(:me)     { create(:user) }
    let!(:other)  { create(:user) }

    let(:mine) do
      conversation = Conversation.create!(product: create(:product, title: "My Product"))
      conversation.participants << [me, other]
      conversation
    end

    let(:not_mine) do
      conversation = Conversation.create!(product: create(:product, title: "Other's Product"))
      conversation.participants << [other]
      conversation
    end

    context "when signed in" do
      before { sign_in me }

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
    let!(:me)           { create(:user) }
    let!(:other)        { create(:user) }
    let!(:conversation) { Conversation.create!(product: create(:product, title: "Detail Page Product")) }

    before { conversation.participants << [me, other] }

    context "when signed in" do
      before { sign_in me }

      it "shows the conversation to a participant" do
        get conversation_path(conversation)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Detail Page Product")
      end

      it "returns 404 to a non-participant" do
        sign_out me
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
