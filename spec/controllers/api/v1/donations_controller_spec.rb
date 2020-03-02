# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DonationsController, type: :controller do
  let(:member) { create(:member) }

  describe '#create' do
    it 'does not assign @donations' do
      post :create
      expect(assigns(:donations)).to be_nil
    end

    it 'responds with unauthorized' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when member' do
      let!(:designation_account_1) { create(:designation_account) }
      let!(:old_donation) { create(:donation, designation_account: designation_account_1, created_at: 2.years.ago) }
      let!(:designation_account_2) { create(:designation_account) }
      let!(:recent_donation) { create(:donation, designation_account: designation_account_2, created_at: 1.month.ago) }
      let!(:new_donation) { create(:donation, designation_account: designation_account_2) }
      let!(:designation_profile) do
        create(:designation_profile, designation_account: designation_account_1, member: member)
      end
      let(:response_body) { CSV.parse(member.donations.as_csv, headers: true).map(&:to_h) }

      before { create(:designation_profile, designation_account: designation_account_2, member: member) }

      it 'assigns @donations' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(assigns(:donations)).to match_array([old_donation, recent_donation, new_donation])
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
        it 'assigns @donations' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
          }
          expect(assigns(:donations)).to eq([old_donation])
        end
      end

      context 'when filtering by date_from' do
        it 'assigns @donations' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, date_from: 1.week.ago.strftime('%m/%d/%Y')
          }
          expect(assigns(:donations)).to eq([new_donation])
        end
      end

      context 'when filtering by date_to' do
        it 'assigns @donations' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, date_to: 2.months.ago.strftime('%m/%d/%Y')
          }
          expect(assigns(:donations)).to eq([old_donation])
        end
      end

      context 'when filtering by date_from and date_to' do
        it 'assigns @donations' do
          post :create, params: {
            user_email: member.email, user_token: member.access_token, date_from: 2.months.ago.strftime('%m/%d/%Y'),
            date_to: 1.week.ago.strftime('%m/%d/%Y')
          }
          expect(assigns(:donations)).to eq([recent_donation])
        end
      end
    end
  end
end
