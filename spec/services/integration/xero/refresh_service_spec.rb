# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::RefreshService, type: :service do
  describe '.refresh?' do
    let(:integration) { create(:integration_xero, valid_credentials: false) }
    let(:refresh_hash) { data('integration/xero/refresh_hash') }

    around do |example|
      freeze_time { example.run }
    end

    before do
      stub_request(:post, 'https://identity.xero.com/connect/token')
        .with(
          body: { 'grant_type' => 'refresh_token', 'refresh_token' => integration.refresh_token },
          headers: {
            'Accept' => 'application/json',
            'Authorization' =>
              'Basic ZjU5MmYzOTUzMGYyMTE3OGJhMzRjNGVjMTdkYzE5YjI6NzIxYmE3MjA4MzBmMDg2NTlkYWY2OGRjYTgwZjliNjQ='
          }
        )
        .to_return(status: 200, body: refresh_hash)
    end

    it 'updates access_token' do
      described_class.refresh?(integration)
      expect(integration.access_token).to eq '3edbf0b4e5b252561fcdb38d47c79c5e'
    end

    it 'updates refresh_token' do
      described_class.refresh?(integration)
      expect(integration.refresh_token).to eq '9107155088e4cb8c588d55c3e4b419a9'
    end

    it 'updates expires_at' do
      described_class.refresh?(integration)
      expect(integration.expires_at).to eq Time.current + 1800
    end

    it 'updates valid_credentials' do
      described_class.refresh?(integration)
      expect(integration.valid_credentials).to eq true
    end

    it 'returns true' do
      expect(described_class.refresh?(integration)).to eq true
    end

    context 'when invalid_grant' do
      let(:integration) { create(:integration_xero, valid_credentials: true) }

      before do
        stub_request(:post, 'https://identity.xero.com/connect/token')
          .to_return(status: 400, body: '{"error":"invalid_grant"}')
      end

      it 'updates valid_credentials' do
        described_class.refresh?(integration)
        expect(integration.valid_credentials).to eq false
      end

      it 'returns false' do
        expect(described_class.refresh?(integration)).to eq false
      end
    end
  end
end
