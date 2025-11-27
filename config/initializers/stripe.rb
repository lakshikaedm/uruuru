stripe_secret_key = ENV["STRIPE_SECRET_KEY"]

if stripe_secret_key.present?
  Stripe.api_key = stripe_secret_key
else
  Rails.logger.warn "Stripe secret key is missing. Stripe is disabled in this environment."
end

Stripe.api_version = "2024-06-20"
