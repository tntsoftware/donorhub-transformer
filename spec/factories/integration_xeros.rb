# frozen_string_literal: true

FactoryBot.define do
  factory :integration_xero, class: 'Integration::Xero' do
    organization
  end
end
