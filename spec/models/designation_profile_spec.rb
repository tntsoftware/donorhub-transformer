# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DesignationProfile, type: :model do
  subject(:designation_profile) { create(:designation_profile) }

  it { is_expected.to belong_to(:designation_account) }
  it { is_expected.to belong_to(:member) }
  it { is_expected.to have_many(:donor_accounts).through(:designation_account) }
  it { is_expected.to have_many(:donations).through(:designation_account) }
  it { is_expected.to validate_uniqueness_of(:designation_account_id).scoped_to(:member_id).case_insensitive }

  describe '.as_csv' do
    let!(:designation_profile1) { create(:designation_profile, created_at: 2.years.ago) }
    let!(:designation_profile2) { create(:designation_profile) }
    let(:data) do
      [
        %w[PROFILE_CODE PROFILE_DESCRIPTION PROFILE_ACCOUNT_REPORT_URL],
        [designation_profile1.id, designation_profile1.name, ''],
        [designation_profile2.id, designation_profile2.name, '']
      ]
    end

    it 'returns csv' do
      expect(CSV.parse(described_class.as_csv)).to match_array(data)
    end
  end

  describe '.balances_as_csv' do
    subject!(:designation_profile) { create(:designation_profile, designation_account: designation_account) }

    let!(:designation_account) { create(:designation_account, balance: 4.5) }
    let(:data) do
      [
        %w[EMPLID ACCT_NAME BALANCE PROFILE_CODE PROFILE_DESCRIPTION FUND_ACCOUNT_REPORT_URL],
        [designation_account.id, designation_account.name, designation_account.balance.to_s, designation_profile.id,
         designation_profile.name, '']
      ]
    end

    it 'returns csv' do
      expect(CSV.parse(described_class.balances_as_csv)).to match_array(data)
    end
  end

  describe '#name' do
    subject(:designation_profile) do
      create(:designation_profile, designation_account: designation_account, member: member)
    end

    let(:designation_account) { create(:designation_account, name: 'designationAccount1') }
    let(:member) { create(:member, user: create(:user, name: 'member1')) }

    it 'concatenates designation_account name and member name' do
      expect(designation_profile.name).to eq 'designationAccount1 | member1'
    end
  end
end
