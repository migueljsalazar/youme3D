Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

# Stripe.api_key = Rails.env.production? ?
#                  Rails.configuration.stripe[:secret_key] :
#                  Settings[Rails.env]['stripe']['secret_key']