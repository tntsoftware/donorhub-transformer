# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::QueriesController, type: :controller do
  let(:organization) { create(:organization) }

  before { request.host = "#{organization.subdomain}.example.com" }

  render_views

  describe '#show' do
    let(:response_body) do
      <<~TXT
        [APPLICATION]
        MinimumVersion=3.1.0
        RecommendedVersion=3.2.5

        [ORGANIZATION]
        RedirectQueryIni=
        Code=#{organization.code}
        Name=#{organization.name}
        Abbreviation=#{organization.code}
        AccountHelpUrl=mailto:#{organization.email}
        RequestProfileUrl=mailto:#{organization.email}
        OrgHelpUrl=mailto:#{organization.email}
        OrgHelpUrlDescription=Click here to report this issue!
        MinimumWebGiftDate=#{organization.minimum_donation_date}
        MinPidLength=
        DefaultCurrencyCode=NZD
        GLAccountCategoriesToConsolidate=

        [PROFILES]
        Url=http://#{organization.subdomain}.example.com/api/v1/designation_profiles
        Post=user_email=$ACCOUNT$&user_token=$PASSWORD$

        [DESIGNATIONS]
        Url=http://#{organization.subdomain}.example.com/api/v1/designation_accounts
        Post=user_email=$ACCOUNT$&user_token=$PASSWORD$&designation_profile_id=$PROFILE$

        [DONATIONS]
        Url=http://#{organization.subdomain}.example.com/api/v1/donations
        Post=user_email=$ACCOUNT$&user_token=$PASSWORD$&designation_profile_id=$PROFILE$&date_from=$DATEFROM$&date_to=$DATETO$

        [ADDRESSES]
        Url=http://#{organization.subdomain}.example.com/api/v1/donor_accounts
        Post=user_email=$ACCOUNT$&user_token=$PASSWORD$&designation_profile_id=$PROFILE$&date_from=$DATEFROM$

        [ADDRESSES_BY_PERSONIDS]
        Url=http://#{organization.subdomain}.example.com/api/v1/donor_accounts
        Post=user_email=$ACCOUNT$&user_token=$PASSWORD$&designation_profile_id=$PROFILE$&donor_account_ids=$PERSONIDS$

        [ACCOUNT_BALANCE]
        Url=http://#{organization.subdomain}.example.com/api/v1/balances
        Post=user_email=$ACCOUNT$&user_token=$PASSWORD$&designation_profile_id=$PROFILE$
      TXT
    end

    it 'renders ini' do
      get :show
      expect(response.body).to eq response_body
    end

    it 'sends data' do
      get :show
      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
    end

    it 'sets filename' do
      get :show
      expect(response.headers['Content-Disposition']).to eq(
        'attachment; filename="query.ini"; filename*=UTF-8\'\'query.ini'
      )
    end
  end
end
