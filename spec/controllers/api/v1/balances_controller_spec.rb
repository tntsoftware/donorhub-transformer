# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BalancesController, type: :controller do
  let(:organization) { create(:organization) }
  let(:member) { create(:member, organization: organization) }

  before { request.host = "#{organization.subdomain}.example.com" }

  describe '#create' do
    it 'does not assign @designation_accounts' do
      post :create
      expect(assigns(:designation_accounts)).to be_nil
    end

    it 'responds with unauthorized' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when member' do
      let!(:designation_account_1) { create(:designation_account, organization: organization) }
      let!(:designation_account_2) { create(:designation_account, organization: organization) }
      let!(:designation_profile) do
        create(:designation_profile, designation_account: designation_account_1, member: member)
      end
      let(:response_body) { CSV.parse(member.designation_accounts.balances_as_csv, headers: true).map(&:to_h) }

      before { create(:designation_profile, designation_account: designation_account_2, member: member) }

      it 'assigns @designation_accounts' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(assigns(:designation_accounts)).to match_array([designation_account_1, designation_account_2])
      end

      it 'responds with ok' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(response).to have_http_status(:ok)
      end

      it 'renders csv' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(CSV.parse(response.body, headers: true).map(&:to_h)).to match_array response_body
      end

      it 'sends data' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(controller.headers['Content-Transfer-Encoding']).to eq('binary')
      end

      context 'when filtering by designation_profile_id' do
        it 'assigns @designation_accounts' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
          }
          expect(assigns(:designation_accounts)).to eq([designation_account_1])
        end
      end
    end
  end
end
