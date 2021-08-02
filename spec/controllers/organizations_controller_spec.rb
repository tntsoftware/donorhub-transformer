# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let(:permitted_params) { [:name] }
  let!(:organization) { create(:organization) }
  let(:user)          { create(:user) }
  let(:attributes) do
    ActionController::Parameters.new(attributes_for(:organization)).permit(permitted_params).to_h
  end

  describe '#show' do
    it 'responds with found' do
      get :show
      expect(response).to have_http_status(:found)
    end

    it 'redirects to edit' do
      get :show
      expect(response).to redirect_to(action: :edit)
    end
  end

  describe '#edit' do
    it 'responds with :unauthorized' do
      get :edit
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when user is admin' do
      before do
        user.add_role(:admin, organization)
        sign_in user
      end

      it 'assigns @organization' do
        get :edit
        expect(assigns(:organization)).to eq organization
      end

      it 'authorizes organization' do
        allow(controller).to receive(:authorize)
        get :edit
        expect(controller).to have_received(:authorize).with(organization)
      end

      it 'responds with ok' do
        get :edit
        expect(response).to have_http_status(:ok)
      end

      it 'decorates organization' do
        get :edit
        expect(controller.organization).to be_decorated
      end
    end
  end

  describe '#update' do
    it 'responds with not_found' do
      put :update, params: { organization: attributes }
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when user is admin' do
      before do
        user.add_role(:admin, organization)
        sign_in user
      end

      it 'updates attributes' do
        put :update, params: { id: organization.slug, organization: attributes }
        expect(assigns(:organization).attributes).to include(attributes)
      end

      it 'updates @organization' do
        put :update, params: { id: organization.slug, organization: attributes }
        expect(assigns(:organization).persisted?).to eq true
      end

      it 'responds with found' do
        put :update, params: { id: organization.slug, organization: attributes }
        expect(response).to have_http_status(:found)
      end

      it 'permits params' do
        expect(response).to permit(*permitted_params)
          .for(:update, params: { id: organization.slug, organization: attributes })
          .on(:organization)
      end

      it 'sets flash' do
        put :update, params: { id: organization.slug, organization: attributes }
        expect(response).to set_flash[:notice].to('organization updated successfully')
      end

      it 'redirects to edit' do
        put :update, params: { id: organization.slug, organization: attributes }
        expect(response).to redirect_to(action: :edit)
      end

      context 'when organization is invalid' do
        let(:invalid_attributes) { attributes.tap { |organization| organization[:name] = nil } }

        it 'updates attributes' do
          put :update, params: { id: organization.slug, organization: invalid_attributes }
          expect(assigns(:organization).name).to be_blank
        end

        it 'does not update @organization' do
          put :update, params: { id: organization.slug, organization: invalid_attributes }
          expect(assigns(:organization)).not_to be_valid
        end

        it 'responds with unprocessable_entity' do
          put :update, params: { id: organization.slug, organization: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
