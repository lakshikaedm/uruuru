# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
  config.mailer_sender = "no-reply@uruuru.example.com"
  facebook_client_id     = ENV.fetch("FACEBOOK_CLIENT_ID", nil)
  facebook_client_secret = ENV.fetch("FACEBOOK_CLIENT_SECRET", nil)

  if facebook_client_id.present? && facebook_client_secret.present?
    config.omniauth :facebook,
                    facebook_client_id,
                    facebook_client_secret,
                    scope: "email",
                    info_fields: "email,name"
  else
    Rails.logger.warn "Facebook OmniAuth is not configured. FACEBOOK_CLIENT_ID / FACEBOOK_CLIENT_SECRET missing."
  end
end
