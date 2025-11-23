require "rails_helper"

RSpec.describe "Products AI description", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "POST /products/generate_description" do
    let(:prompt) { "Used Sony camera, good condition, includes battery and strap." }

    it "returns generated description as JSON" do
      service_double = instance_double(Products::GenerateDescription, call: "Nice camera description")
      allow(Products::GenerateDescription).to receive(:new)
        .and_return(service_double)

      post generate_description_products_path,
           params: { prompt: prompt },
           as: :json

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json["description"]).to eq("Nice camera description")
      expect(Products::GenerateDescription).to have_received(:new)
        .with(prompt: prompt, locale: I18n.locale)
    end

    it "returns error when prompt is blank" do
      service_double = instance_double(
        Products::GenerateDescription,
        call: I18n.t("products.ai_description.errors.blank_prompt")
      )
      allow(Products::GenerateDescription).to receive(:new)
        .and_return(service_double)

      post generate_description_products_path,
           params: { prompt: "" },
           as: :json

      expect(response).to have_http_status(:unprocessable_content)
      json = response.parsed_body
      expect(json["error"]).to eq(I18n.t("products.ai_description.errors.blank_prompt"))
      expect(Products::GenerateDescription).to have_received(:new)
    end
  end
end
