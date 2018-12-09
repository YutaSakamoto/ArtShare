Rails.configuration.stripe = {
  :publishable_key => 'pk_test_6JWcmrQNa5ft8BkuoztvmVxV',
  :secret_key => 'sk_test_l2qFQB2Az2zmC0lyWMtXa1Y4'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
