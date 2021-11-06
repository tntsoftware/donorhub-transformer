# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    type { 'Integration::Xero' }
    remote_id { SecureRandom.uuid }
  end
end
