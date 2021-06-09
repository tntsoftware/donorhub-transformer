# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::DesignationAccounts', type: :request do
  let(:organization) { create(:organization) }
  let(:member) { create(:member) }

  before { host! "#{organization.subdomain}.example.com" }

  describe '#create' do
    it 'returns authentication error' do
      post '/api/v1/designation_accounts'
      expect(response.status).to eq(401)
    end

    it 'returns empty CSV' do
      post '/api/v1/designation_accounts', params: { user_email: member.email, user_token: member.access_token }
      expect(CSV.parse(response.body)).to eq([%w[DESIG_ID DESIG_NAME ORG_PATH]])
    end

    context 'when multiple designation_profiles' do
      let(:designation_account1) { create(:designation_account) }
      let(:designation_account2) { create(:designation_account) }
      let(:data) do
        [
          %w[DESIG_ID DESIG_NAME ORG_PATH],
          [designation_account1.id, designation_account1.name, ''],
          [designation_account2.id, designation_account2.name, '']
        ]
      end

      before do
        create(:designation_profile, member: member, designation_account: designation_account1)
        create(:designation_profile, member: member, designation_account: designation_account2)
      end

      it 'returns designation_accounts in CSV format' do
        post '/api/v1/designation_accounts', params: { user_email: member.email, user_token: member.access_token }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end

    context 'when designation_profile provided' do
      let(:designation_account) { create(:designation_account) }
      let(:designation_profile) do
        create(:designation_profile, member: member, designation_account: designation_account)
      end
      let(:data) do
        [
          %w[DESIG_ID DESIG_NAME ORG_PATH],
          [designation_account.id, designation_account.name, '']
        ]
      end

      before { create(:designation_profile, member: member) }

      it 'returns designation_account in CSV format' do
        post '/api/v1/designation_accounts', params: {
          user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
        }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end
  end
end
