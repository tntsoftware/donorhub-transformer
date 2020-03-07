# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::CreateService, type: :service do
  let(:auth_hash) { json_data('integration/xero/auth_hash') }
  let(:organization) { create(:organization) }

  describe '.create' do
    let(:integration) { organization.integrations.first }
    let(:tenants) do
      [{ 'createdDateUtc' => '2020-03-05T03:50:41.1405030',
         'id' => '8e261456-339a-4c46-8c10-aef97c403f56',
         'tenantId' => '94faa28f3-9f32-478d-8ed8-a9099124f977',
         'tenantType' => 'ORGANISATION',
         'updatedDateUtc' => '2020-03-05T06:11:13.5022330' }]
    end

    it 'creates an integration' do
      expect { described_class.create(organization, auth_hash) }.to change(Integration::Xero, :count).from(0).to(1)
    end

    it 'sets remote_id' do
      described_class.create(organization, auth_hash)
      expect(integration.remote_id).to eq('d609b4f7-74af-413b-852f-7fb04f1f33ce')
    end

    it 'sets access_token' do
      described_class.create(organization, auth_hash)
      expect(integration.access_token).to eq('8f516a2ecb5071edeea1f9c1187fc2dc38938440c96a39f0d48d49aba2803c00')
    end

    it 'sets refresh_token' do
      described_class.create(organization, auth_hash)
      expect(integration.refresh_token).to eq('7bff1468510623bc7f5e5ae2c706ebab90179da38334ad6d62b3c99200872367')
    end

    it 'sets expires_at' do
      described_class.create(organization, auth_hash)
      expect(integration.expires_at).to eq(Time.at(1_583_544_506))
    end

    it 'sets auth_hash' do
      described_class.create(organization, auth_hash)
      expect(integration.auth_hash).to eq(auth_hash)
    end

    it 'sets primary_tenant_id' do
      described_class.create(organization, auth_hash)
      expect(integration.primary_tenant_id).to eq('94faa28f3-9f32-478d-8ed8-a9099124f977')
    end

    it 'sets tenants' do
      described_class.create(organization, auth_hash)
      expect(integration.tenants).to eq(tenants)
    end

    context 'when integration already exists' do
      let!(:integration) do
        create(:integration_xero, organization: organization, remote_id: 'd609b4f7-74af-413b-852f-7fb04f1f33ce')
      end

      it 'does not creates an integration' do
        expect { described_class.create(organization, auth_hash) }.not_to change(Integration::Xero, :count)
      end

      it 'sets access_token' do
        described_class.create(organization, auth_hash)
        expect(integration.reload.access_token).to eq(
          '8f516a2ecb5071edeea1f9c1187fc2dc38938440c96a39f0d48d49aba2803c00'
        )
      end
    end
  end
end
