# frozen_string_literal: true

# == Schema Information
#
# Table name: donations
#
#  id                     :uuid             not null, primary key
#  amount                 :decimal(, )
#  currency               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  designation_account_id :uuid             not null
#  donor_account_id       :uuid             not null
#  remote_id              :string
#
# Indexes
#
#  index_donations_on_designation_account_id  (designation_account_id)
#  index_donations_on_donor_account_id        (donor_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (designation_account_id => designation_accounts.id) ON DELETE => cascade
#  fk_rails_...  (donor_account_id => donor_accounts.id) ON DELETE => cascade
#

require 'csv'
require 'rails_helper'

RSpec.describe Donation, type: :model do
  it { is_expected.to belong_to(:designation_account) }
  it { is_expected.to belong_to(:donor_account) }

  describe '.by_date_range' do
    let!(:old_donation) { create(:donation, created_at: 2.years.ago) }
    let!(:recent_donation) { create(:donation, created_at: 1.month.ago) }
    let!(:new_donation) { create(:donation) }

    it 'returns all donations by default' do
      expect(described_class.by_date_range(nil, nil)).to match_array([old_donation, recent_donation, new_donation])
    end

    it 'returns new donation' do
      expect(described_class.by_date_range(1.week.ago, nil)).to eq([new_donation])
    end

    it 'returns recent donation' do
      expect(described_class.by_date_range(2.months.ago, 1.week.ago)).to eq([recent_donation])
    end

    it 'returns old donation' do
      expect(described_class.by_date_range(nil, 2.months.ago)).to eq([old_donation])
    end
  end

  describe '.as_csv' do
    let!(:donor_account) { create(:donor_account, name: Faker::Name.name) }
    let!(:donation) { create(:donation, donor_account: donor_account, amount: 10, currency: 'USD') }
    let!(:donation_as_csv) do
      {
        'PEOPLE_ID' => donor_account.id,
        'ACCT_NAME' => donor_account.name,
        'DISPLAY_DATE' => Time.now.utc.to_date.strftime('%m/%d/%Y'),
        'AMOUNT' => '10.0',
        'DONATION_ID' => donation.id,
        'DESIGNATION' => donation.designation_account_id,
        'MOTIVATION' => '',
        'PAYMENT_METHOD' => '',
        'MEMO' => '',
        'TENDERED_AMOUNT' => '10.0',
        'TENDERED_CURRENCY' => 'USD',
        'ADJUSTMENT_TYPE' => ''
      }
    end

    it 'returns donations in CSV format' do
      rows = CSV.parse(described_class.as_csv, headers: true)
      expect(rows[0].to_h).to eq(donation_as_csv)
    end
  end

  describe '#member_and_designation_account_have_same_organization' do
    subject(:donation) do
      build(:donation, designation_account: designation_account, donor_account: donor_account)
    end

    let(:organization) { create(:organization) }
    let(:designation_account) { create(:designation_account, organization: organization) }
    let(:donor_account) { create(:donor_account, organization: organization) }

    it { is_expected.to be_valid }

    context 'when different organizations' do
      let(:donor_account) { create(:donor_account) }

      it { is_expected.not_to be_valid }
    end
  end
end
