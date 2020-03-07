# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_profiles
#
#  id                     :uuid             not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  designation_account_id :uuid             not null
#  member_id              :uuid             not null
#  remote_id              :string
#
# Indexes
#
#  index_designation_profiles_on_designation_account_id  (designation_account_id)
#  index_designation_profiles_on_member_id               (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (designation_account_id => designation_accounts.id) ON DELETE => cascade
#  fk_rails_...  (member_id => members.id) ON DELETE => cascade
#

require 'rails_helper'

RSpec.describe DesignationProfile, type: :model do
  it { is_expected.to belong_to(:designation_account) }
  it { is_expected.to belong_to(:member) }
  it { is_expected.to have_many(:donor_accounts).through(:designation_account) }
  it { is_expected.to have_many(:donations).through(:designation_account) }

  describe '.as_csv' do
    let(:designation_profile) do
      create(:designation_profile, designation_account: designation_account, member: member)
    end
    let(:organization) { create(:organization) }
    let(:designation_account) { create(:designation_account, name: Faker::Name.name, organization: organization) }
    let(:member) { create(:member, name: Faker::Name.name, organization: organization) }
    let!(:designation_profile_as_csv) do
      {
        'PROFILE_CODE' => designation_profile.id,
        'PROFILE_DESCRIPTION' => "#{designation_account.name} | #{member.name}",
        'PROFILE_ACCOUNT_REPORT_URL' => ''
      }
    end

    it 'returns donations in CSV format' do
      rows = CSV.parse(described_class.as_csv, headers: true)
      expect(rows[0].to_h).to eq(designation_profile_as_csv)
    end

    context 'when remote_id set' do
      let(:designation_profile) do
        create(
          :designation_profile, designation_account: designation_account, member: member, remote_id: SecureRandom.uuid
        )
      end
      let!(:designation_profile_as_csv) do
        {
          'PROFILE_CODE' => designation_profile.remote_id,
          'PROFILE_DESCRIPTION' => "#{designation_account.name} | #{member.name}",
          'PROFILE_ACCOUNT_REPORT_URL' => ''
        }
      end

      it 'returns donations in CSV format' do
        rows = CSV.parse(described_class.as_csv, headers: true)
        expect(rows[0].to_h).to eq(designation_profile_as_csv)
      end
    end
  end

  describe '#name' do
    subject(:designation_profile) do
      create(:designation_profile, designation_account: designation_account, member: member)
    end

    let(:organization) { create(:organization) }
    let(:designation_account) { create(:designation_account, name: Faker::Name.name, organization: organization) }
    let(:member) { create(:member, name: Faker::Name.name, organization: organization) }

    it 'returns name of designation_account and member' do
      expect(designation_profile.name).to eq "#{designation_account.name} | #{member.name}"
    end

    context 'when designation_account and member are nil' do
      subject(:designation_profile) { build(:designation_profile, designation_account: nil, member: nil) }

      it 'returns nil' do
        expect(designation_profile.name).to eq nil
      end
    end
  end

  describe '#member_and_designation_account_have_same_organization' do
    subject(:designation_profile) do
      build(:designation_profile, designation_account: designation_account, member: member)
    end

    let(:organization) { create(:organization) }
    let(:designation_account) { create(:designation_account, organization: organization) }
    let(:member) { create(:member, organization: organization) }

    it { is_expected.to be_valid }

    context 'when different organizations' do
      let(:member) { create(:member) }

      it { is_expected.not_to be_valid }
    end
  end
end
