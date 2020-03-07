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

    trait :with_primary_tenant do
      before(:create) do |integration|
        integration.primary_tenant_id = integration.tenants.first['tenantId']
      end
    end
  end
end
