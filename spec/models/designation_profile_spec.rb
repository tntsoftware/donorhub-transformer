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

  describe '#name' do
    subject(:designation_profile) do
      create(:designation_profile, designation_account: designation_account, member: member)
    end

    let(:designation_account) { create(:designation_account, name: Faker::Name.name) }
    let(:member) { create(:member, name: Faker::Name.name) }

    it 'returns name of designation_account and member' do
      expect(designation_profile.name).to eq "#{designation_account.name} | #{member.name}"
    end
  end

  describe '.as_csv' do
    let(:designation_profile) do
      create(:designation_profile, designation_account: designation_account, member: member)
    end
    let(:designation_account) { create(:designation_account, name: Faker::Name.name) }
    let(:member) { create(:member, name: Faker::Name.name) }
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
  end
end
