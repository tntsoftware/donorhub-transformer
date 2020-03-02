# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DonorAccountsController, type: :controller do
  let(:member) { create(:member) }

  describe '#create' do
    it 'does not assign @donor_accounts' do
      post :create
      expect(assigns(:donor_accounts)).to be_nil
    end

    it 'responds with unauthorized' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when member' do
      let!(:designation_account_1) { create(:designation_account) }
      let!(:old_donor_account) { create(:donor_account, updated_at: 2.years.ago) }
      let!(:designation_account_2) { create(:designation_account) }
      let!(:recent_donor_account) { create(:donor_account, updated_at: 1.month.ago) }
      let!(:new_donor_account) { create(:donor_account) }
      let!(:designation_profile) do
        create(:designation_profile, designation_account: designation_account_1, member: member)
      end
      let(:response_body) { CSV.parse(member.donor_accounts.distinct.as_csv, headers: true).map(&:to_h) }

      before do
        create(:designation_profile, designation_account: designation_account_2, member: member)
        create(:donation, designation_account: designation_account_1, donor_account: old_donor_account)
        create(:donation, designation_account: designation_account_1, donor_account: old_donor_account)
        create(:donation, designation_account: designation_account_2, donor_account: recent_donor_account)
        create(:donation, designation_account: designation_account_2, donor_account: new_donor_account)
      end

      it 'assigns @donor_accounts' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(assigns(:donor_accounts)).to match_array(
          [old_donor_account, recent_donor_account, new_donor_account]
        )
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
        it 'assigns @donor_accounts' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
          }
          expect(assigns(:donor_accounts)).to eq([old_donor_account])
        end
      end

      context 'when filtering by date_from' do
        it 'assigns @donor_accounts' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, date_from: 1.week.ago.strftime('%m/%d/%Y')
          }
          expect(assigns(:donor_accounts)).to eq([new_donor_account])
        end
      end

      context 'when filtering by date_to' do
        it 'assigns @donor_accounts' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, date_to: 2.months.ago.strftime('%m/%d/%Y')
          }
          expect(assigns(:donor_accounts)).to eq([old_donor_account])
        end
      end

      context 'when filtering by date_from and date_to' do
        it 'assigns @donor_accounts' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, date_from: 2.months.ago.strftime('%m/%d/%Y'),
            date_to: 1.week.ago.strftime('%m/%d/%Y')
          }
          expect(assigns(:donor_accounts)).to eq([recent_donor_account])
        end
      end

      context 'when filtering by donor_account_ids' do
        it 'assigns @donor_accounts' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token,
            donor_account_ids: "#{old_donor_account.id},#{recent_donor_account.id}"
          }
          expect(assigns(:donor_accounts)).to match_array([old_donor_account, recent_donor_account])
        end
      end
    end
  end
end
