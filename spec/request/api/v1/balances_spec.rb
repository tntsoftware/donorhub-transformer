# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Balances", type: :request do
  let(:organization) { create(:organization) }
  let(:member) { create(:member) }

  before { host! "#{organization.subdomain}.example.com" }

  describe "#create" do
    it "returns authentication error" do
      post "/api/v1/balances"
      expect(response.status).to eq(401)
    end

    it "returns empty CSV" do
      post "/api/v1/balances", params: {user_email: member.email, user_token: member.access_token}
      expect(CSV.parse(response.body)).to eq(
        [%w[EMPLID ACCT_NAME BALANCE PROFILE_CODE PROFILE_DESCRIPTION FUND_ACCOUNT_REPORT_URL]]
      )
    end

    context "when multiple designation_profiles" do
      let(:designation_profile1) { create(:designation_profile, member: member) }
      let(:designation_profile2) { create(:designation_profile, member: member) }
      let!(:data) do
        [
          %w[EMPLID ACCT_NAME BALANCE PROFILE_CODE PROFILE_DESCRIPTION FUND_ACCOUNT_REPORT_URL],
          [designation_profile1.designation_account.id, designation_profile1.designation_account.name,
            designation_profile1.designation_account.balance.to_s, designation_profile1.id, designation_profile1.name,
            ""],
          [designation_profile2.designation_account.id, designation_profile2.designation_account.name,
            designation_profile2.designation_account.balance.to_s, designation_profile2.id, designation_profile2.name,
            ""]
        ]
      end

      it "returns designation_profiles balances in CSV format" do
        post "/api/v1/balances", params: {user_email: member.email, user_token: member.access_token}
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end

    context "when designation_profile provided" do
      let!(:designation_profile) do
        create(:designation_profile, designation_account: designation_account, member: member)
      end
      let!(:designation_account) { create(:designation_account, balance: 4.5) }
      let(:data) do
        [
          %w[EMPLID ACCT_NAME BALANCE PROFILE_CODE PROFILE_DESCRIPTION FUND_ACCOUNT_REPORT_URL],
          [designation_account.id, designation_account.name, designation_account.balance.to_s, designation_profile.id,
            designation_profile.name, ""]
        ]
      end

      it "returns designation_profile balances in CSV format" do
        post "/api/v1/balances", params: {
          user_email: member.email, user_token: member.access_token, designation_profile_id: designation_profile.id
        }
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end
  end
end
