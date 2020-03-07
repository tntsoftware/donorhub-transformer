# frozen_string_literal: true

FactoryBot.define do
  factory :integration_xero, class: 'Integration::Xero', parent: :integration do
    tenants do
      [{
        'id' => SecureRandom.uuid,
        'tenantId' => SecureRandom.uuid,
        'tenantType' => 'ORGANISATION',
        'createdDateUtc' => Time.now.to_s,
        'updatedDateUtc' => Time.now.to_s
      }]
    end
  end
end
