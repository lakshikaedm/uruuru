require "openai"

OPENAI_CLIENT = if Rails.env.test?
                  OpenAI::Client.new(api_key: "test-key")
                else
                  OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY", nil))
                end
