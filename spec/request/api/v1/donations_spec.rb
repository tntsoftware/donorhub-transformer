# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Donations', type: :request do
  let(:organization) { create(:organization) }
  let(:member) { create(:member) }

  describe '#create' do
    let(:data) do
      [
        %w[PEOPLE_ID ACCT_NAME DISPLAY_DATE AMOUNT DONATION_ID DESIGNATION MOTIVATION PAYMENT_METHOD MEMO
           TENDERED_AMOUNT TENDERED_CURRENCY ADJUSTMENT_TYPE]
      ]
    end

    it 'returns authentication error' do
      post "/organizations/#{organization.slug}/api/v1/donations"
      expect(response.status).to eq(401)
    end

    it 'returns empty CSV' do
      post "/organizations/#{organization.slug}/api/v1/donations",
           params: { user_email: member.email, user_token: member.access_token }
      expect(CSV.parse(response.body)).to eq(data)
    end

    context 'when multiple donations' do
      let(:donation1) { create(:donation) }
      let(:donation2) { create(:donation) }
      let!(:data) do
        [
          %w[PEOPLE_ID ACCT_NAME DISPLAY_DATE AMOUNT DONATION_ID DESIGNATION MOTIVATION PAYMENT_METHOD MEMO
             TENDERED_AMOUNT TENDERED_CURRENCY ADJUSTMENT_TYPE],
          [
            donation1.donor_account_id, donation1.donor_account.name, donation1.created_at.strftime('%m/%d/%Y'),
            donation1.amount.to_s, donation1.id, donation1.designation_account_id, '', '', '', donation1.amount.to_s,
            donation1.currency, ''
          ],
          [
            donation2.donor_account_id, donation2.donor_account.name, donation2.created_at.strftime('%m/%d/%Y'),
            donation2.amount.to_s, donation2.id, donation2.designation_account_id, '', '', '', donation2.amount.to_s,
            donation2.currency, ''
          ]
        ]
      end

      before do
        create(:designation_profile, member: member, designation_account: donation1.designation_account)
        create(:designation_profile, member: member, designation_account: donation2.designation_account)
      end

      it 'returns donations in CSV format' do
        post "/organizations/#{organization.slug}/api/v1/donations",
             params: { user_email: member.email, user_token: member.access_token }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end

    context 'when filtered by designation_profile' do
      let(:donation) { create(:donation, designation_account: designation_profile.designation_account) }
      let(:designation_profile) { create(:designation_profile, member: member) }
      let!(:data) do
        [
          %w[PEOPLE_ID ACCT_NAME DISPLAY_DATE AMOUNT DONATION_ID DESIGNATION MOTIVATION PAYMENT_METHOD MEMO
             TENDERED_AMOUNT TENDERED_CURRENCY ADJUSTMENT_TYPE],
          [
            donation.donor_account_id, donation.donor_account.name, donation.created_at.strftime('%m/%d/%Y'),
            donation.amount.to_s, donation.id, donation.designation_account_id, '', '', '', donation.amount.to_s,
            donation.currency, ''
          ]
        ]
      end

      before do
        designation_profile1 = create(:designation_profile, member: member)
        create(:donation, designation_account: designation_profile1.designation_account)
      end

      it 'returns donations in CSV format' do
        post "/organizations/#{organization.slug}/api/v1/donations", params: {
          user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
        }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end
  end

  context 'when filtered by date_from and date_to' do
    let(:donation) do
      create(:donation, updated_at: 2.years.ago, designation_account: designation_profile.designation_account)
    end
    let(:designation_profile) { create(:designation_profile, member: member) }
    let!(:data) do
      [
        %w[PEOPLE_ID ACCT_NAME DISPLAY_DATE AMOUNT DONATION_ID DESIGNATION MOTIVATION PAYMENT_METHOD MEMO
           TENDERED_AMOUNT TENDERED_CURRENCY ADJUSTMENT_TYPE],
        [
          donation.donor_account_id, donation.donor_account.name, donation.created_at.strftime('%m/%d/%Y'),
          donation.amount.to_s, donation.id, donation.designation_account_id, '', '', '', donation.amount.to_s,
          donation.currency, ''
        ]
      ]
    end

    before do
      designation_profile1 = create(:designation_profile, member: member)
      create(:donation, designation_account: designation_profile1.designation_account)
    end

    it 'returns donations in CSV format' do
      post "/organizations/#{organization.slug}/api/v1/donations", params: {
        user_email: member.email, user_token: member.access_token,
        date_from: (2.years.ago - 1.day).strftime('%m/%d/%Y'), date_to: (2.years.ago + 1.day).strftime('%m/%d/%Y')
      }
      expect(CSV.parse(response.body)).to match_array(data)
    end
  end
end
