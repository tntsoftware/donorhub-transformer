# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::Sync::DesignationAccount::BalancesService, type: :service do
  let(:organization) { create(:organization) }
  let(:integration) do
    create(:integration_xero, :with_primary_tenant, access_token: SecureRandom.hex, organization: organization)
  end
  let(:balances_sheet) { data('integration/xero/balance_sheet') }

  describe '#sync' do
    subject(:balances_service) { described_class.new(integration) }

    before do
      stub_request(:get, "https://api.xero.com/api.xro/2.0/Reports/BalanceSheet?date=#{Date.today}")
        .with(
          headers: {
            'Authorization' => "Bearer #{integration.access_token}",
            'Xero-Tenant-Id' => integration.primary_tenant_id
          }
        )
        .to_return(status: 200, body: balances_sheet, headers: {})
    end

    it 'does not create new designation_account' do
      expect { balances_service.sync }.not_to(change { organization.designation_accounts.count })
    end

    context 'when designation_account exists' do
      let!(:designation_account) do
        create(:designation_account, organization: organization, remote_id: '8392357c-a8c8-42ab-8bdb-6a9ee2062364')
      end

      it 'sets balance' do
        balances_service.sync
        expect(designation_account.reload.balance).to eq(-400.01)
      end
    end

    context 'when invalid token' do
      let(:token_expired) { data('integration/xero/token_expired') }

      before do
        allow(Integration::Xero::RefreshService).to receive(:refresh?).with(integration) {
          integration.update(access_token: 'new_token')
        }
        stub_request(:get, "https://api.xero.com/api.xro/2.0/Reports/BalanceSheet?date=#{Date.today}")
          .with(
            headers: {
              'Authorization' => "Bearer #{integration.access_token}",
              'Xero-Tenant-Id' => integration.primary_tenant_id
            }
          )
          .to_return(status: 401, body: token_expired, headers: {})
        stub_request(:get, "https://api.xero.com/api.xro/2.0/Reports/BalanceSheet?date=#{Date.today}")
          .with(
            headers: {
              'Authorization' => 'Bearer new_token',
              'Xero-Tenant-Id' => integration.primary_tenant_id
            }
          )
          .to_return(status: 200, body: balances_sheet, headers: {})
      end

      it 'refreshes token' do
        balances_service.sync
        expect(WebMock).to have_requested(
          :get, "https://api.xero.com/api.xro/2.0/Reports/BalanceSheet?date=#{Date.today}"
        ).with(headers: { 'Authorization' => 'Bearer new_token' })
      end
    end
  end
end
