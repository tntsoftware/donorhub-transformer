# frozen_string_literal: true

require 'rails_helper'

describe Integration::PrimarySyncService, type: :service do
  let(:integration) { create(:integration_xero) }

  describe '.sync' do
    around do |example|
      freeze_time { example.run }
    end

    it 'call sync service' do
      allow(Integration::Xero::SyncService).to receive(:sync)
      described_class.sync(integration)
      expect(Integration::Xero::SyncService).to have_received(:sync).with(integration)
    end

    it 'set locked_at' do
      allow(Integration::Xero::SyncService).to receive(:sync) do
        expect(integration.locked_at).to eq Time.current
      end
      described_class.sync(integration)
    end

    it 'set last_download_attempted_at' do
      allow(Integration::Xero::SyncService).to receive(:sync) do
        expect(integration.last_download_attempted_at).to eq Time.current
      end
      described_class.sync(integration)
    end

    it 'set last_download_at' do
      allow(Integration::Xero::SyncService).to receive(:sync)
      described_class.sync(integration)
      expect(integration.last_downloaded_at).to eq Time.current
    end

    context 'when synce service raises error' do
      before do
        allow(Integration::Xero::SyncService).to receive(:sync) { raise StandardError }
      end

      it 'raises error' do
        expect { described_class.sync(integration) }.to raise_error(StandardError)
      end

      it 'set locked_at to nil' do
        described_class.sync(integration)
      rescue StandardError
        expect(integration.locked_at).to be_nil
      end
    end

    context 'when locked_at is not nil' do
      let(:integration) { create(:integration_xero, locked_at: Time.now) }

      it 'does not run sync service' do
        allow(Integration::Xero::SyncService).to receive(:sync)
        described_class.sync(integration)
        expect(Integration::Xero::SyncService).not_to have_received(:sync).with(integration)
      end
    end
  end
end
