# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    organization
    type { 'Integration::Xero' }
    remote_id { SecureRandom.uuid }
  end
end
