# frozen_string_literal: true

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

  describe '#create_access_token' do
    subject(:member) { build(:member) }

    it 'sets access_token to access_token' do
      allow(SecureRandom).to receive(:base58).with(24).and_return('access_token')
      member.save
      expect(member.access_token).to eq('access_token')
    end

    context 'when access_token already set' do
      before { create(:member, access_token: 'access_token') }

      it 'sets access_token to access_token_1' do
        allow(SecureRandom).to receive(:base58).with(24).and_return('access_token', 'access_token_1')
        member.save
        expect(member.access_token).to eq('access_token_1')
      end
    end
  end
end
