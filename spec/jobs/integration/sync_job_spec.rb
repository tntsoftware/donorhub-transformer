# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::SyncJob, type: :job do
  subject(:job) { described_class.perform_later(integration.id) }

  let(:integration) { create(:integration) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class).with(integration.id).on_queue('default')
  end

  describe '#perform' do
    subject(:job) { described_class.new }

    it 'calls sync service' do
      allow(Integration::SyncService).to receive(:sync).with(integration)
      job.perform(integration.id)
      expect(Integration::SyncService).to have_receive(:sync)
    end

    context 'when unknown integration_id' do
      it 'does not raise_error' do
        expect { job.perform(SecureRandom.uuid) }.not_to raise_error
      end
    end
  end
end
