require "rails_helper"

class FakeChat
  def completions; end
end

class FakeCompletions
  def create(*); end
end

RSpec.describe Products::GenerateDescription do
  let(:prompt) { "Red Nike sneakers, size 26cm, slightly used." }

  describe "#call" do
    it "returns description from OpenAI" do
      api_response = {
        "choices" => [
          {
            "message" => {
              "content" => "Nice generated description"
            }
          }
        ]
      }

      client_double      = instance_double(OpenAI::Client)
      chat_double        = instance_double(FakeChat)
      completions_double = instance_double(FakeCompletions)

      service = described_class.new(prompt: prompt, locale: :en)

      allow(service).to receive(:client).and_return(client_double)
      allow(client_double).to receive(:chat).and_return(chat_double)
      allow(chat_double).to receive(:completions).and_return(completions_double)
      allow(completions_double).to receive(:create).and_return(api_response)

      result = service.call

      expect(result).to eq("Nice generated description")
    end

    it "returns blank prompt fallback when prompt is empty" do
      result = described_class.new(prompt: "", locale: :en).call

      expect(result).to eq(
        I18n.t("products.ai_description.errors.blank_prompt")
      )
    end
  end
end
