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
  subject(:designation_profile) { create(:designation_profile) }

  it { is_expected.to belong_to(:designation_account) }
  it { is_expected.to belong_to(:member) }
  it { is_expected.to have_many(:donor_accounts).through(:designation_account) }
  it { is_expected.to have_many(:donations).through(:designation_account) }

  describe '.as_csv' do
    let!(:designation_profile1) { create(:designation_profile, created_at: 2.years.ago) }
    let!(:designation_profile2) { create(:designation_profile) }

    it 'returns csv' do
      expect(described_class.as_csv).to eq(
        <<~CSV
          PROFILE_CODE,PROFILE_DESCRIPTION,PROFILE_ACCOUNT_REPORT_URL
          #{designation_profile1.id},#{designation_profile1.name},""
          #{designation_profile2.id},#{designation_profile2.name},""
        CSV
      )
    end
  end

  describe '#name' do
    subject(:designation_profile) do
      create(:designation_profile, designation_account: designation_account, member: member)
    end

    let(:designation_account) { create(:designation_account, name: 'designationAccount1') }
    let(:member) { create(:member, name: 'member1') }

    it 'concatenates designation_account name and member name' do
      expect(designation_profile.name).to eq 'designationAccount1 | member1'
    end
  end
end
