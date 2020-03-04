# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration, type: :model do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_inclusion_of(:type).in_array(['Integration::Xero']) }

  describe '#sync' do
    subject(:integration) { create(:integration_xero) }

    it 'enqueues a sync job' do
      expect { integration.sync }.to(
        have_enqueued_job(Integration::SyncJob).with(integration.id)
      )
    end
  end
end
