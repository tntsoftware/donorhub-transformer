# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::DonorAccounts', type: :request do
  let(:member) { create(:member) }

  describe '#show' do
    it 'returns binary file' do
      get '/api/v1/query'
      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
    end

    it 'returns query.ini' do
      get '/api/v1/query'
      expect(response.body).to eq file_fixture('api/v1/query.ini').read
    end
  end
end
