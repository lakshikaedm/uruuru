module Products
  class GenerateDescription
    def initialize(prompt:, locale: I18n.locale)
      @prompt = prompt.to_s.strip
      @locale = locale
    end

    def call
      return fallback_blank_prompt if @prompt.blank?
      return fallback_missing_key if ENV["OPENAI_API_KEY"].blank?

      response = client.chat.completions.create(
        model: "gpt-4.1-mini",
        messages: [
          { role: "system", content: system_prompt },
          { role: "user",   content: user_prompt }
        ],
        temperature: 0.7
      )

      content = extract_content(response)
      content.to_s.strip.presence || fallback_generic_error
    rescue StandardError => e
      Rails.logger.error("[AI_DESCRIPTION] #{e.class}: #{e.message}")
      fallback_generic_error
    end

    private

    def client
      defined?(OPENAI_CLIENT) ? OPENAI_CLIENT : OpenAI::Client.new
    end

    def system_prompt
      <<~PROMPT
        You are a copywriter for an online marketplace called "Uruuru".
        Write concise, appealing product descriptions.

        Requirements:
        - Tone: friendly and trustworthy.
        - Length: about 2–4 sentences.
        - Avoid marketing buzzword spam.
        - Never invent specs that aren't in the input.
        - If the input is in Japanese or Sinhala, respond in that language.
        - If the input mixes languages, choose the dominant language.
      PROMPT
    end

    def user_prompt
      <<~PROMPT
        Write a product description based on these raw specs:

        #{@prompt}
      PROMPT
    end

    # ---- Response parsing without #dig ----

    def extract_content(response)
      message = extract_message_from_object(response) ||
                extract_message_from_hash(response)
      return unless message

      extract_content_from_message(message)
    end

    def extract_message_from_object(response)
      return unless response.respond_to?(:choices)

      first_choice = Array(response.choices).first
      return unless first_choice

      if first_choice.respond_to?(:message)
        first_choice.message
      elsif first_choice.is_a?(Hash)
        first_choice[:message] || first_choice["message"]
      end
    end

    def extract_message_from_hash(response)
      return unless response.respond_to?(:to_h)

      data = response.to_h
      choices = data[:choices] || data["choices"]
      first_choice = Array(choices).first
      return unless first_choice

      first_choice[:message] || first_choice["message"]
    end

    def extract_content_from_message(message)
      if message.respond_to?(:content)
        message.content
      elsif message.is_a?(Hash)
        message[:content] || message["content"]
      end
    end

    def fallback_blank_prompt
      I18n.t("products.ai_description.errors.blank_prompt")
    end

    def fallback_missing_key
      I18n.t("products.ai_description.errors.missing_api_key")
    end

    def fallback_generic_error
      I18n.t("products.ai_description.errors.generic")
    end
  end
end
