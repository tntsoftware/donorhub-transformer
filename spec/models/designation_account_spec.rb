# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default("false")
#  balance    :decimal(, )      default("0")
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

require 'rails_helper'

RSpec.describe DesignationAccount, type: :model do
  it { is_expected.to have_many(:designation_profiles).dependent(:destroy) }
  it { is_expected.to have_many(:donations).dependent(:destroy) }
  it { is_expected.to have_many(:donor_accounts).through(:donations) }

  describe '.active' do
    before { create(:designation_account, active: false) }

    let(:designation_account) { create(:designation_account, active: true) }

    it 'returns active designation_account' do
      expect(described_class.active).to eq([designation_account])
    end
  end

  describe '.inactive' do
    before { create(:designation_account, active: true) }

    let(:designation_account) { create(:designation_account, active: false) }

    it 'returns inactive designation_account' do
      expect(described_class.inactive).to eq([designation_account])
    end
  end

  describe '.as_csv' do
    let!(:designation_account) { create(:designation_account, name: Faker::Name.name) }
    let!(:designation_account_as_csv) do
      {
        'DESIG_ID' => designation_account.id,
        'DESIG_NAME' => designation_account.name,
        'ORG_PATH' => ''
      }
    end

    it 'returns designation_accounts in CSV format' do
      rows = CSV.parse(described_class.as_csv, headers: true)
      expect(rows[0].to_h).to eq(designation_account_as_csv)
    end
  end

  describe '.balances_as_csv' do
    let!(:designation_account_1) { create(:designation_account, name: Faker::Name.name, balance: 10) }
    let!(:designation_account_2) { create(:designation_account, name: Faker::Name.name, balance: 20) }
    let!(:designation_profile) { create(:designation_profile, designation_account: designation_account_1) }
    let!(:balances_as_csv) do
      {
        'EMPLID' => "#{designation_account_1.id},#{designation_account_2.id}",
        'ACCT_NAME' => "#{designation_account_1.name},#{designation_account_2.name}",
        'BALANCE' => '10.0,20.0',
        'PROFILE_CODE' => designation_profile.id,
        'PROFILE_DESCRIPTION' => designation_profile.name,
        'FUND_ACCOUNT_REPORT_URL' => ''
      }
    end

    it 'returns balances in CSV format' do
      rows = CSV.parse(described_class.balances_as_csv(designation_profile), headers: true)
      expect(rows[0].to_h).to eq(balances_as_csv)
    end

    context 'when no designation_profile' do
      let!(:balances_as_csv) do
        {
          'EMPLID' => "#{designation_account_1.id},#{designation_account_2.id}",
          'ACCT_NAME' => "#{designation_account_1.name},#{designation_account_2.name}",
          'BALANCE' => '10.0,20.0',
          'PROFILE_CODE' => '',
          'PROFILE_DESCRIPTION' => '',
          'FUND_ACCOUNT_REPORT_URL' => ''
        }
      end

      it 'returns balances in CSV format' do
        rows = CSV.parse(described_class.balances_as_csv, headers: true)
        expect(rows[0].to_h).to eq(balances_as_csv)
      end
    end
  end
end
