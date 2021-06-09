# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::DonorAccounts', type: :request do
  let(:organization) { create(:organization) }
  let(:member) { create(:member) }

  before { host! "#{organization.subdomain}.example.com" }

  describe '#show' do
    it 'returns binary file' do
      get '/api/v1/query'
      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
    end

    context 'when organization set' do
      let(:organization) do
        create(
          :organization,
          code: '60-2994465',
          name: 'Stark, Legros and Conroy',
          abbreviation: 'Group',
          account_help_url: 'http://stroman.io/nicola',
          request_profile_url: 'http://douglas.co/leandro',
          help_url: 'http://quigley.com/charley.wolff',
          help_description: 'Sartorial tattooed 3 wolf moon freegan keytar yolo shoreditch goth.',
          currency_code: 'ARS',
          subdomain: 'tester'
        )
      end

      it 'returns query.ini' do
        get '/api/v1/query'
        expect(response.body).to eq file_fixture('api/v1/query.ini').read
      end
    end
  end
end
