# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    organization
    type { 'Integration::Xero' }
  end
end
