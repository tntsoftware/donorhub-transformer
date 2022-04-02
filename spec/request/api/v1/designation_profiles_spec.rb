# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::DesignationProfiles", type: :request do
  let(:organization) { create(:organization) }
  let(:member) { create(:member) }

  before { host! "#{organization.subdomain}.example.com" }

  describe "#create" do
    it "returns authentication error" do
      post "/api/v1/designation_profiles"
      expect(response.status).to eq(401)
    end

    it "returns empty CSV" do
      post "/api/v1/designation_profiles", params: {user_email: member.email, user_token: member.access_token}
      expect(CSV.parse(response.body)).to eq([%w[PROFILE_CODE PROFILE_DESCRIPTION PROFILE_ACCOUNT_REPORT_URL]])
    end

    context "when multiple designation_profiles" do
      let(:designation_profile1) { create(:designation_profile, member: member) }
      let(:designation_profile2) { create(:designation_profile, member: member) }
      let!(:data) do
        [
          %w[PROFILE_CODE PROFILE_DESCRIPTION PROFILE_ACCOUNT_REPORT_URL],
          [designation_profile1.id, designation_profile1.name, ""],
          [designation_profile2.id, designation_profile2.name, ""]
        ]
      end

      it "returns designation_profiles in CSV format" do
        post "/api/v1/designation_profiles", params: {user_email: member.email, user_token: member.access_token}
        expect(CSV.parse(response.body)).to match_array(data)
      end
    end
  end
end
