require "rails_helper"

RSpec.describe "Profile", type: :request do
  let(:user) { create(:user) }

  it "redirects when not signed in" do
    get profile_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "shows profile when signed in" do
    sign_in user
    get profile_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(user.email)
  end
end
