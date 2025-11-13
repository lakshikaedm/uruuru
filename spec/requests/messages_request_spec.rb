require "rails_helper"

RSpec.describe "Messages", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "POST /conversations/:conversation_id/messages" do
    let!(:me)       { create(:user) }
    let!(:other)    { create(:user) }
    let!(:stranger) { create(:user) }
    let!(:product)  { create(:product) }

    let!(:conversation) do
      conversation = Conversation.create(product: product)
      conversation.participants << [me, other]
      conversation
    end

    context "when signed in" do
      before { sign_in me }

      it "creates a message and redirect back to the conversation" do
        expect { post conversation_messages_path(conversation), params: { message: { body: "Hello there" } } }
          .to change(Message, :count).by(1)
        expect(response).to redirect_to(conversation_path(conversation))
      end

      it "rejects empty body with 422 or re-render" do
        expect { post conversation_messages_path(conversation), params: { message: { body: "" } } }
          .not_to change(Message, :count)
        expect(response).to have_http_status(*unprocessable_entity).or have_http_status(:ok)
      end

      it "returns 403 for non-participants" do
        sign_out me
        sign_in stranger

        expect { post conversation_messages_path, params: { message: { body: "I should not post" } } }
          .not_to change(Message, :count)
        expect(response).to have_http_status(:forbidden)
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
