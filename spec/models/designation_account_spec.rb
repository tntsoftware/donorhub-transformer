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
  it { is_expected.to belong_to(:organization) }
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
    let!(:designation_account) { create(:designation_account, name: Faker::Name.name, remote_id: SecureRandom.uuid) }
    let!(:designation_account_as_csv) do
      {
        'DESIG_ID' => designation_account.remote_id,
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
    let(:organization) { create(:organization) }
    let(:member) { create(:member, organization: organization) }
    let!(:designation_account_1) do
      create(
        :designation_account,
        name: Faker::Name.name,
        balance: 10,
        organization: organization,
        remote_id: SecureRandom.uuid
      )
    end
    let!(:designation_account_2) do
      create(
        :designation_account,
        name: Faker::Name.name,
        balance: 20,
        organization: organization,
        remote_id: SecureRandom.uuid
      )
    end
    let!(:designation_profile) do
      create(:designation_profile, designation_account: designation_account_1, member: member)
    end
    let!(:balances_as_csv) do
      {
        'EMPLID' => "#{designation_account_1.remote_id},#{designation_account_2.remote_id}",
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

    context 'when designation_profile has remote_id' do
      let!(:designation_profile) do
        create(
          :designation_profile, designation_account: designation_account_1, member: member, remote_id: SecureRandom.uuid
        )
      end
      let!(:balances_as_csv) do
        {
          'EMPLID' => "#{designation_account_1.remote_id},#{designation_account_2.remote_id}",
          'ACCT_NAME' => "#{designation_account_1.name},#{designation_account_2.name}",
          'BALANCE' => '10.0,20.0',
          'PROFILE_CODE' => designation_profile.remote_id,
          'PROFILE_DESCRIPTION' => designation_profile.name,
          'FUND_ACCOUNT_REPORT_URL' => ''
        }
      end

      it 'returns balances in CSV format' do
        rows = CSV.parse(described_class.balances_as_csv(designation_profile), headers: true)
        expect(rows[0].to_h).to eq(balances_as_csv)
      end
    end

    context 'when no designation_profile' do
      let!(:balances_as_csv) do
        {
          'EMPLID' => "#{designation_account_1.remote_id},#{designation_account_2.remote_id}",
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
