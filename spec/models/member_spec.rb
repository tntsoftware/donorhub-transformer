# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id           :uuid             not null, primary key
#  access_token :string           not null
#  email        :string           not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  remote_id    :string
#
# Indexes
#
#  index_members_on_email_and_access_token  (email,access_token) UNIQUE
#

require 'rails_helper'

RSpec.describe Member, type: :model do
  subject(:member) { create(:member) }

  it { is_expected.to have_many(:designation_profiles).dependent(:destroy) }
  it { is_expected.to have_many(:designation_accounts).through(:designation_profiles) }
  it { is_expected.to have_many(:donations).through(:designation_accounts) }
  it { is_expected.to have_many(:donor_accounts).through(:donations) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:access_token).scoped_to(:email) }

  describe '#send_inform_email' do
    subject(:member) { build(:member) }

    it 'sends inform email on create' do
      allow(MemberMailer).to receive(:inform).and_call_original
      member.save
      expect(MemberMailer).to have_received(:inform).with(member)
    end
  end
end
