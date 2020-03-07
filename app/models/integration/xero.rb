# frozen_string_literal: true

class Integration::Xero < Integration
  store :metadata, accessors: %i[tenants primary_tenant_id]
  validates :tenants, presence: true
end
