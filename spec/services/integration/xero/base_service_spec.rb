# frozen_string_literal: true

require 'rails_helper'

describe Integration::Xero::BaseService, type: :service do
  let(:integration) { create(:integration_xero) }

  describe '.sync' do
    let(:service) { described_class.new(integration) }

    before do
      allow(described_class).to receive(:new).and_return(service)
      allow(service).to receive(:sync)
    end

    it 'initialize new instance' do
      described_class.sync(integration)
      expect(described_class).to have_received(:new).with(integration)
    end

    it 'calls sync on the new instance' do
      described_class.sync(integration)
      expect(service).to have_received(:sync)
    end
  end
end
