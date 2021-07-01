# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :xero_oauth2,
    ENV['XERO_API_CLIENT_ID'],
    ENV['XERO_API_CLIENT_SECRET'],
    scope: 'openid profile email offline_access'
  )
  provider(:developer)
end
