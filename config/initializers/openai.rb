require "openai"

OPENAI_API_KEY = ENV.fetch("OPENAI_API_KEY", nil)

OPENAI_CLIENT =
  if OPENAI_API_KEY.present?
    OpenAI::Client.new(api_key: OPENAI_API_KEY)
  else
    Rails.logger.warn "OpenAI API key is missing. AI features are disabled."
    nil
  end
