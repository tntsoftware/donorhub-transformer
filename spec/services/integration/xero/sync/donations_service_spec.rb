# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::Sync::DonationsService, type: :service do
  let(:organization) { create(:organization) }
  let(:integration) do
    create(:integration_xero, :with_primary_tenant, access_token: SecureRandom.hex, organization: organization)
  end
  let(:bank_transactions_1) { data('integration/xero/bank_transactions-1') }
  let(:bank_transactions_2) { data('integration/xero/bank_transactions-2') }
  let(:bank_transactions_empty) { data('integration/xero/bank_transactions-empty') }
  let!(:donor_account_1) do
    create(:donor_account, organization: organization, remote_id: 'e5797369-d308-4870-93b5-10c84fa9e381')
  end
  let!(:donor_account_2) do
    create(:donor_account, organization: organization, remote_id: 'a4ca6606-2fa2-4e15-9650-4b14755a26ad')
  end
  let!(:designation_account_1) do
    create(
      :designation_account,
      organization: organization,
      active: true,
      code: '000.AAA'
    )
  end
  let!(:designation_account_2) do
    create(
      :designation_account,
      organization: organization,
      active: true,
      code: '000.CCC'
    )
  end
  let!(:deleted_donation) do
    create(
      :donation,
      donor_account: donor_account_1,
      designation_account: designation_account_1,
      remote_updated_at: 2.years.ago
    )
  end

  def url(page)
    'https://api.xero.com/api.xro/2.0/BankTransactions'\
    "?page=#{page}&where=Type==%22RECEIVE%22%20and%20Status==%22AUTHORISED%22"
  end

  describe '#sync' do
    subject(:donations_service) { described_class.new(integration) }

    let(:donation) { organization.donations.find_by(remote_id: 'a21a1fb7-6dbe-44fd-9089-09cc12f4c3ca') }

    before do
      stub_request(:get, url(1))
        .with(
          headers: {
            'Authorization' => "Bearer #{integration.access_token}",
            'Xero-Tenant-Id' => integration.primary_tenant_id
          }
        )
        .to_return(status: 200, body: bank_transactions_1, headers: {})
      stub_request(:get, url(2))
        .with(
          headers: {
            'Authorization' => "Bearer #{integration.access_token}",
            'Xero-Tenant-Id' => integration.primary_tenant_id
          }
        )
        .to_return(status: 200, body: bank_transactions_2, headers: {})
      stub_request(:get, url(3))
        .with(
          headers: {
            'Authorization' => "Bearer #{integration.access_token}",
            'Xero-Tenant-Id' => integration.primary_tenant_id
          }
        )
        .to_return(status: 200, body: bank_transactions_empty, headers: {})
    end

    it 'create new donations' do
      expect { donations_service.sync }.to change { organization.donations.count }.from(1).to(2)
    end

    it 'sets remote_id' do
      donations_service.sync
      expect(donation.remote_id).to eq 'a21a1fb7-6dbe-44fd-9089-09cc12f4c3ca'
    end

    it 'sets designation_account' do
      donations_service.sync
      expect(donation.designation_account).to eq designation_account_1
    end

    it 'sets donor_account' do
      donations_service.sync
      expect(donation.donor_account).to eq donor_account_1
    end

    it 'sets amount' do
      donations_service.sync
      expect(donation.amount).to eq 20.20
    end

    it 'sets currency' do
      donations_service.sync
      expect(donation.currency).to eq 'NZD'
    end

    it 'sets remote_updated_at' do
      donations_service.sync
      expect(donation.remote_updated_at).to eq Time.new(2012, 6, 20, 1, 42, 39, 0)
    end

    it 'sets created_at' do
      donations_service.sync
      expect(donation.created_at).to eq Time.new(2012, 5, 31, 0, 0, 0, 0)
    end

    it 'deletes removed donation' do
      donations_service.sync
      expect { deleted_donation.reload }.to raise_error(ActiveRecord::RecordNotFound)
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
        donations_service.sync
        expect(WebMock).to have_requested(:get, url(1)).with(
          headers: { 'If-Modified-Since' => integration.last_downloaded_at.to_date }
        )
      end

      it 'does not delete removed donation' do
        donations_service.sync
        expect { deleted_donation.reload }.not_to raise_error
      end
    end

    context 'when donation already exists' do
      let!(:donation) do
        create(
          :donation,
          donor_account: donor_account_1,
          designation_account: designation_account_1,
          remote_id: 'a21a1fb7-6dbe-44fd-9089-09cc12f4c3ca'
        )
      end

      before do
        create(
          :donation,
          donor_account: donor_account_2,
          designation_account: designation_account_2,
          remote_id: '5259b709-f758-4317-8ad0-d4a0f8e7e6a2'
        )
      end

      it 'does not create new donation' do
        expect { donations_service.sync }.to change { organization.donations.count }.from(3).to(2)
      end

      it 'sets amount' do
        donations_service.sync
        expect(donation.reload.amount).to eq 20.20
      end
    end

    context 'when invalid token' do
      let(:token_expired) { data('integration/xero/token_expired') }

      before do
        allow(Integration::Xero::RefreshService).to receive(:refresh?).with(integration) {
          integration.update(access_token: 'new_token')
        }
        stub_request(:get, url(1))
          .with(
            headers: {
              'Authorization' => "Bearer #{integration.access_token}",
              'Xero-Tenant-Id' => integration.primary_tenant_id
            }
          )
          .to_return(status: 401, body: token_expired, headers: {})
        stub_request(:get, url(1))
          .with(
            headers: {
              'Authorization' => 'Bearer new_token',
              'Xero-Tenant-Id' => integration.primary_tenant_id
            }
          )
          .to_return(status: 200, body: bank_transactions_empty, headers: {})
      end

      it 'refreshes token' do
        donations_service.sync
        expect(WebMock).to have_requested(:get, url(1)).with(
          headers: { 'Authorization' => 'Bearer new_token' }
        )
      end
    end
  end
end
