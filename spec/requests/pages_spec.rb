require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /about" do
    it "returns http success" do
      get about_path(locale: I18n.locale)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /release_notes" do
    it "returns http success" do
      get release_notes_path(locale: I18n.locale)
      expect(response).to have_http_status(:success)
    end
  end
end
