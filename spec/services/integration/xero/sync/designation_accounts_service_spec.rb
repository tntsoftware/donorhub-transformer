# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::Sync::DesignationAccountsService, type: :service do
  let(:organization) { create(:organization) }
  let(:integration) do
    create(:integration_xero, :with_primary_tenant, access_token: SecureRandom.hex, organization: organization)
  end
  let(:accounts) { data('integration/xero/accounts') }

  describe '#sync' do
    subject(:designation_accounts_service) { described_class.new(integration) }

    let(:designation_account) { organization.designation_accounts.first }

    before do
      stub_request(:get, 'https://api.xero.com/api.xro/2.0/Accounts')
        .with(
          headers: {
            'Authorization' => "Bearer #{integration.access_token}",
            'Xero-Tenant-Id' => integration.primary_tenant_id
          }
        )
        .to_return(status: 200, body: accounts, headers: {})
    end

    it 'create new designation_account' do
      expect { designation_accounts_service.sync }.to change { organization.designation_accounts.count }.from(0).to(1)
    end

    it 'sets remote_id' do
      designation_accounts_service.sync
      expect(designation_account.remote_id).to eq '68d15431-f27d-4ec5-8cee-c1910cd3be6c'
    end

    it 'sets name' do
      designation_accounts_service.sync
      expect(designation_account.name).to eq 'MTS 2020 AA Donations Receivable'
    end

    it 'sets code' do
      designation_accounts_service.sync
      expect(designation_account.code).to eq '1000.AA'
    end

    it 'sets remote_updated_at' do
      designation_accounts_service.sync
      expect(designation_account.remote_updated_at).to eq Time.new(2016, 12, 21, 2, 27, 11, 0)
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
        designation_accounts_service.sync
        expect(WebMock).to have_requested(:get, 'https://api.xero.com/api.xro/2.0/Accounts').with(
          headers: { 'If-Modified-Since' => integration.last_downloaded_at.to_date }
        )
      end
    end

    context 'when designation_account already exists' do
      let!(:designation_account) do
        create(:designation_account, organization: organization, remote_id: '68d15431-f27d-4ec5-8cee-c1910cd3be6c')
      end

      it 'does not create new designation_account' do
        expect { designation_accounts_service.sync }.not_to change { organization.designation_accounts.count }
      end

      it 'sets name' do
        designation_accounts_service.sync
        expect(designation_account.reload.name).to eq 'MTS 2020 AA Donations Receivable'
      end
    end
  end
end
