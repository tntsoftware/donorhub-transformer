# frozen_string_literal: true

# == Schema Information
#
# Table name: donor_accounts
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

require 'rails_helper'

RSpec.describe DonorAccount, type: :model do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:donations).dependent(:destroy) }

  describe '.by_date_range' do
    let!(:old_donor_account) { create(:donor_account, updated_at: 2.years.ago) }
    let!(:recent_donor_account) { create(:donor_account, updated_at: 1.month.ago) }
    let!(:new_donor_account) { create(:donor_account) }

    it 'returns all donor_accounts by default' do
      expect(described_class.by_date_range(nil, nil)).to match_array(
        [old_donor_account, recent_donor_account, new_donor_account]
      )
    end

    it 'returns new donor_account' do
      expect(described_class.by_date_range(1.week.ago, nil)).to eq([new_donor_account])
    end

    it 'returns recent donor_account' do
      expect(described_class.by_date_range(2.months.ago, 1.week.ago)).to eq([recent_donor_account])
    end

    it 'returns old donor_account' do
      expect(described_class.by_date_range(nil, 2.months.ago)).to eq([old_donor_account])
    end
  end

  describe '.as_csv' do
    let!(:donor_account) { create(:donor_account, name: Faker::Name.name, remote_id: SecureRandom.uuid) }
    let!(:donor_account_as_csv) do
      {
        'PEOPLE_ID' => donor_account.remote_id,
        'ACCT_NAME' => donor_account.name
      }
    end

    it 'returns donor_accounts in CSV format' do
      rows = CSV.parse(described_class.as_csv, headers: true)
      expect(rows[0].to_h).to eq(donor_account_as_csv)
    end
  end
end
