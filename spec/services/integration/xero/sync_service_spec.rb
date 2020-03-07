# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::SyncService, type: :service do
  let(:integration) { create(:integration_xero) }

  describe '.sync' do
    before do
      allow(Integration::Xero::Sync::DonorAccountsService).to receive(:sync).with(integration)
      allow(Integration::Xero::Sync::DesignationAccountsService).to receive(:sync).with(integration)
      allow(Integration::Xero::Sync::DonationsService).to receive(:sync).with(integration)
      allow(Integration::Xero::Sync::DesignationAccount::BalancesService).to receive(:sync).with(integration)
    end

    it 'calls DonorAccountsService.sync' do
      described_class.sync(integration)
      expect(Integration::Xero::Sync::DonorAccountsService).to have_received(:sync).with(integration)
    end

    it 'calls DesignationAccountsService.sync' do
      described_class.sync(integration)
      expect(Integration::Xero::Sync::DesignationAccountsService).to have_received(:sync).with(integration)
    end

    it 'calls DonationsService.sync' do
      described_class.sync(integration)
      expect(Integration::Xero::Sync::DonationsService).to have_received(:sync).with(integration)
    end

    it 'calls BalancesService.sync' do
      described_class.sync(integration)
      expect(Integration::Xero::Sync::DesignationAccount::BalancesService).to have_received(:sync).with(integration)
    end
  end
end
