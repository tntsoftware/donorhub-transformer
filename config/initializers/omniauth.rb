# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :xero_oauth2,
    ENV.fetch('XERO_API_CLIENT_ID'),
    ENV.fetch('XERO_API_CLIENT_SECRET'),
    scope: 'openid email profile accounting.transactions.read accounting.reports.read accounting.contacts.read '\
           'accounting.settings.read offline_access'
  )
end
