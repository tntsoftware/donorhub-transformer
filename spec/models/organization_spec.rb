# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  subject(:organization) { create(:organization) }

  it { is_expected.to have_many(:members).dependent(:destroy) }
  it { is_expected.to have_many(:donor_accounts).dependent(:destroy) }
  it { is_expected.to have_many(:designation_accounts).dependent(:destroy) }
  it { is_expected.to have_many(:integrations).dependent(:destroy) }
  it { is_expected.to have_many(:xero_integrations).dependent(:destroy) }
  it { is_expected.to have_many(:donations).through(:donor_accounts) }
  it { is_expected.to validate_presence_of(:name) }
end
