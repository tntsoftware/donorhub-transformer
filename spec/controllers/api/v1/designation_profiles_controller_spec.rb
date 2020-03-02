# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DesignationProfilesController, type: :controller do
  let(:member) { create(:member) }

  describe '#create' do
    it 'does not assign @designation_profiles' do
      post :create
      expect(assigns(:designation_profiles)).to be_nil
    end

    it 'responds with unauthorized' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when member' do
      let!(:designation_profile_1) { create(:designation_profile, member: member) }
      let!(:designation_profile_2) { create(:designation_profile, member: member) }
      let(:response_body) { CSV.parse(member.designation_profiles.as_csv, headers: true).map(&:to_h) }

      before { create(:designation_profile) }

      it 'assigns @designation_profiles' do
        post :create, params: { user_email: member.email, user_token: member.access_token }
        expect(assigns(:designation_profiles)).to match_array([designation_profile_1, designation_profile_2])
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
    end
  end
end
