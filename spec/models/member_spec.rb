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
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:designation_profiles).dependent(:destroy) }
  it { is_expected.to have_many(:designation_accounts).through(:designation_profiles) }
  it { is_expected.to have_many(:donations).through(:designation_accounts) }
  it { is_expected.to have_many(:donor_accounts).through(:donations) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }

  describe '#create_access_token' do
    subject(:member) { create(:member) }

    it 'create access_token' do
      expect(member.access_token).not_to be_nil
    end
  end

  describe '#send_inform_email' do
    it 'sends an email' do
      expect { create(:member) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
