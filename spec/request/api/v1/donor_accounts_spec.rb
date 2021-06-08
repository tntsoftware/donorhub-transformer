# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::DonorAccounts', type: :request do
  let(:member) { create(:member) }

  describe '#create' do
    it 'returns authentication error' do
      post '/api/v1/donor_accounts'
      expect(response.status).to eq(401)
    end

    it 'returns empty CSV' do
      post '/api/v1/donor_accounts', params: { user_email: member.email, user_token: member.access_token }
      expect(CSV.parse(response.body)).to eq([%w[PEOPLE_ID ACCT_NAME]])
    end

    context 'when multiple donor_accounts' do
      let(:donor_account1) { create(:donor_account) }
      let(:donor_account2) { create(:donor_account) }
      let!(:data) do
        [
          %w[PEOPLE_ID ACCT_NAME],
          [donor_account1.id, donor_account1.name],
          [donor_account2.id, donor_account2.name]
        ]
      end

      before do
        designation_profile1 = create(:designation_profile, member: member)
        designation_profile2 = create(:designation_profile, member: member)
        create(:donation, donor_account: donor_account1, designation_account: designation_profile1.designation_account)
        create(:donation, donor_account: donor_account1, designation_account: designation_profile2.designation_account)
        create(:donation, donor_account: donor_account2, designation_account: designation_profile2.designation_account)
      end

      it 'returns donor_accounts in CSV format' do
        post '/api/v1/donor_accounts', params: { user_email: member.email, user_token: member.access_token }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end

    context 'when filtered by designation_profile' do
      let(:donor_account) { create(:donor_account) }
      let(:designation_profile) { create(:designation_profile, member: member) }
      let!(:data) do
        [
          %w[PEOPLE_ID ACCT_NAME],
          [donor_account.id, donor_account.name]
        ]
      end

      before do
        designation_profile1 = create(:designation_profile, member: member)
        create(:donation, donor_account: donor_account, designation_account: designation_profile.designation_account)
        create(:donation, donor_account: donor_account, designation_account: designation_profile1.designation_account)
        create(:donation, designation_account: designation_profile1.designation_account)
      end

      it 'returns donor_accounts in CSV format' do
        post '/api/v1/donor_accounts', params: {
          user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
        }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end
  end

  context 'when filtered by date_from and date_to' do
    let(:donor_account) { create(:donor_account, updated_at: 2.years.ago) }
    let(:designation_profile) { create(:designation_profile, member: member) }
    let!(:data) do
      [
        %w[PEOPLE_ID ACCT_NAME],
        [donor_account.id, donor_account.name]
      ]
    end

    before do
      designation_profile1 = create(:designation_profile, member: member)
      create(:donation, donor_account: donor_account, designation_account: designation_profile.designation_account)
      create(:donation, donor_account: donor_account, designation_account: designation_profile1.designation_account)
      create(:donation, designation_account: designation_profile1.designation_account)
    end

    it 'returns donor_accounts in CSV format' do
      post '/api/v1/donor_accounts', params: {
        user_email: member.email, user_token: member.access_token,
        date_from: (2.years.ago - 1.day).strftime('%m/%d/%Y'), date_to: (2.years.ago + 1.day).strftime('%m/%d/%Y')
      }
      expect(CSV.parse(response.body)).to match_array(data)
    end
  end

  context 'when filtered by donor_account_ids' do
    let(:donor_account) { create(:donor_account, updated_at: 2.years.ago) }
    let(:designation_profile) { create(:designation_profile, member: member) }
    let!(:data) do
      [
        %w[PEOPLE_ID ACCT_NAME],
        [donor_account.id, donor_account.name]
      ]
    end

    before do
      designation_profile1 = create(:designation_profile, member: member)
      create(:donation, donor_account: donor_account, designation_account: designation_profile.designation_account)
      create(:donation, donor_account: donor_account, designation_account: designation_profile1.designation_account)
      create(:donation, designation_account: designation_profile1.designation_account)
    end

    it 'returns donor_accounts in CSV format' do
      post '/api/v1/donor_accounts', params: {
        user_email: member.email, user_token: member.access_token,
        donor_account_ids: "#{donor_account.id},#{SecureRandom.uuid}"
      }
      expect(CSV.parse(response.body)).to match_array(data)
    end
  end
end
