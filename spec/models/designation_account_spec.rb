# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(FALSE)
#  balance    :decimal(, )      default(0.0)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

require 'rails_helper'

RSpec.describe DesignationAccount, type: :model do
  subject(:designation_account) { create(:designation_account) }

  it { is_expected.to have_many(:designation_profiles).dependent(:destroy) }
  it { is_expected.to have_many(:donations).dependent(:destroy) }
  it { is_expected.to have_many(:donor_accounts).through(:donations) }

  describe '.active' do
    let!(:active) { create(:designation_account, active: true) }

    before { create(:designation_account, active: false) }

    it 'returns active designation_accounts' do
      expect(described_class.active).to eq([active])
    end
  end

  describe '.inactive' do
    let!(:inactive) { create(:designation_account, active: false) }

    before { create(:designation_account, active: true) }

    it 'returns inactive designation_accounts' do
      expect(described_class.inactive).to eq([inactive])
    end
  end

  describe '.as_csv' do
    let!(:designation_account1) { create(:designation_account, created_at: 2.years.ago) }
    let!(:designation_account2) { create(:designation_account) }
    let(:data) do
      [
        %w[DESIG_ID DESIG_NAME ORG_PATH],
        [designation_account1.id, designation_account1.name, ''],
        [designation_account2.id, designation_account2.name, '']
      ]
    end

    it 'returns csv' do
      expect(CSV.parse(described_class.as_csv)).to match_array(data)
    end
  end

  describe '.balances_as_csv' do
    subject!(:designation_account) { create(:designation_account, balance: 4.5) }

    let!(:designation_profile) { create(:designation_profile, designation_account: designation_account) }
    let(:data) do
      [
        %w[EMPLID ACCT_NAME BALANCE PROFILE_CODE PROFILE_DESCRIPTION FUND_ACCOUNT_REPORT_URL],
        [designation_account.id, designation_account.name, designation_account.balance.to_s, designation_profile.id,
         designation_profile.name, '']
      ]
    end

    it 'returns csv' do
      expect(CSV.parse(described_class.balances_as_csv(designation_profile))).to match_array(data)
    end
  end
end
