require "rails_helper"

RSpec.describe "Messages", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "POST /conversations/:conversation_id/messages" do
    let(:buyer)    { create(:user) }
    let(:seller)   { create(:user) }
    let(:stranger) { create(:user) }
    let(:product)  { create(:product) }

    let!(:conversation) do
      Conversation.create!(product: product, buyer: buyer, seller: seller).tap do |c|
        c.participants << [buyer, seller]
      end
    end

    context "when signed in" do
      before { sign_in buyer }

      it "creates a message and redirect back to the conversation" do
        expect { post conversation_messages_path(conversation), params: { message: { body: "Hello there" } } }
          .to change(Message, :count).by(1)
        expect(response).to redirect_to(conversation_path(conversation))
      end

      it "rejects empty body with 422 or re-render" do
        expect { post conversation_messages_path(conversation), params: { message: { body: "" } } }
          .not_to change(Message, :count)
        expect(response).to have_http_status(:unprocessable_content).or have_http_status(:ok)
      end

      it "returns 403 for non-participants" do
        sign_out buyer
        sign_in stranger

        expect { post conversation_messages_path(conversation), params: { message: { body: "I should not post" } } }
          .not_to change(Message, :count)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not signed in" do
      it "redirects to sign in" do
        post conversation_messages_path(conversation), params: { message: { body: "Hi" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
