require "rails_helper"

RSpec.describe "PostalCodes", type: :request do
  describe "GET /postal_code" do
    it "returns 400 when postal_code is missing" do
      get "/postal_code"
      expect(response).to have_http_status(:bad_request)
      json = response.parsed_body
      expect(json["error"]).to eq("missing_postal_code")
      expect(json["message"]).to eq(I18n.t("postal_codes.errors.missing_postal_code"))
    end

    it "returns 404 when not found (stub external API)" do
      stub_request(:get, /zipcloud\.ibsnet\.co\.jp/).to_return(
        status: 200,
        body: { results: nil }.to_json
      )

      get "/postal_code", params: { postal_code: "0000000" }
      expect(response).to have_http_status(:not_found)
    end

    it "returns address JSON when success" do
      stub_request(:get, /zipcloud\.ibsnet\.co\.jp/).to_return(
        status: 200,
        body: {
          results: [
            { "address1" => "東京都", "address2" => "渋谷区", "address3" => "神南" }
          ]
        }.to_json
      )

      get "/postal_code", params: { postal_code: "1500041" }

      expect(response).to have_http_status(:ok)
      json = response.parsed_body

      expect(json.slice("prefecture_ja", "prefecture_en", "city")).to eq(
        "prefecture_ja" => "東京都",
        "prefecture_en" => "Tokyo",
        "city" => "渋谷区神南"
      )
    end
  end
end
