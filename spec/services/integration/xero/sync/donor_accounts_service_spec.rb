# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::Sync::DonorAccountsService, type: :service do
  let(:organization) { create(:organization) }
  let(:integration) do
    create(:integration_xero, :with_primary_tenant, access_token: SecureRandom.hex, organization: organization)
  end
  let(:contacts) { data('integration/xero/contacts') }

  describe '#sync' do
    subject(:donor_accounts_service) { described_class.new(integration) }

    let(:donor_account) { organization.donor_accounts.first }

    before do
      stub_request(:get, 'https://api.xero.com/api.xro/2.0/Contacts')
        .with(
          headers: {
            'Authorization' => "Bearer #{integration.access_token}",
            'Xero-Tenant-Id' => integration.primary_tenant_id
          }
        )
        .to_return(status: 200, body: contacts, headers: {})
    end

    it 'create new donor_account' do
      expect { donor_accounts_service.sync }.to change { organization.donor_accounts.count }.from(0).to(1)
    end

    it 'sets remote_id' do
      donor_accounts_service.sync
      expect(donor_account.remote_id).to eq '1ff6366d-6324-47e7-823d-dba0cd03dc8e'
    end

    it 'sets name' do
      donor_accounts_service.sync
      expect(donor_account.name).to eq 'Ernesto Heathcote'
    end

    it 'sets code' do
      donor_accounts_service.sync
      expect(donor_account.code).to eq 'AA000001'
    end

    it 'sets remote_updated_at' do
      donor_accounts_service.sync
      expect(donor_account.remote_updated_at).to eq Time.new(2020, 3, 5, 8, 23, 15, 0)
    end

    context 'when last_downloaded_at set' do
      let(:integration) do
        create(
          :integration_xero,
          :with_primary_tenant,
          access_token: SecureRandom.hex,
          organization: organization,
          last_downloaded_at: Time.current
        )
      end

      around do |example|
        freeze_time { example.run }
      end

      it 'includes if_modified_since in request' do
        donor_accounts_service.sync
        expect(WebMock).to have_requested(:get, 'https://api.xero.com/api.xro/2.0/Contacts').with(
          headers: { 'If-Modified-Since' => integration.last_downloaded_at.to_date }
        )
      end
    end

    context 'when donor_account already exists' do
      let!(:donor_account) do
        create(:donor_account, organization: organization, remote_id: '1ff6366d-6324-47e7-823d-dba0cd03dc8e')
      end

      it 'does not create new donor_account' do
        expect { donor_accounts_service.sync }.not_to(change { organization.donor_accounts.count })
      end

      it 'sets name' do
        donor_accounts_service.sync
        expect(donor_account.reload.name).to eq 'Ernesto Heathcote'
      end
    end

    context 'when invalid token' do
      let(:token_expired) { data('integration/xero/token_expired') }

      before do
        allow(Integration::Xero::RefreshService).to receive(:refresh?).with(integration) {
          integration.update(access_token: 'new_token')
        }
        stub_request(:get, 'https://api.xero.com/api.xro/2.0/Contacts')
          .with(
            headers: {
              'Authorization' => "Bearer #{integration.access_token}",
              'Xero-Tenant-Id' => integration.primary_tenant_id
            }
          )
          .to_return(status: 401, body: token_expired, headers: {})
        stub_request(:get, 'https://api.xero.com/api.xro/2.0/Contacts')
          .with(
            headers: {
              'Authorization' => 'Bearer new_token',
              'Xero-Tenant-Id' => integration.primary_tenant_id
            }
          )
          .to_return(status: 200, body: contacts, headers: {})
      end

      it 'refreshes token' do
        donor_accounts_service.sync
        expect(WebMock).to have_requested(:get, 'https://api.xero.com/api.xro/2.0/Contacts').with(
          headers: { 'Authorization' => 'Bearer new_token' }
        )
      end
    end
  end
end
