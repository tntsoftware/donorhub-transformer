# frozen_string_literal: true

require "rails_helper"

RSpec.describe Donation, type: :model do
  subject(:donation) { create(:donation) }

  it { is_expected.to belong_to(:designation_account) }
  it { is_expected.to belong_to(:donor_account) }

  describe ".by_date_range" do
    let!(:old_donation) { create(:donation, updated_at: 2.years.ago) }
    let!(:new_donation) { create(:donation) }

    it "returns all donations" do
      expect(described_class.by_date_range(nil, nil)).to match_array([old_donation, new_donation])
    end

    it "returns new donation when date_from" do
      expect(described_class.by_date_range(1.year.ago, nil)).to match_array([new_donation])
    end

    it "returns old donation when date_to" do
      expect(described_class.by_date_range(nil, 1.year.ago)).to match_array([old_donation])
    end

    it "returns old donation when date_from and date_to" do
      expect(described_class.by_date_range(3.years.ago, 1.year.ago)).to match_array([old_donation])
    end
  end

  describe ".as_csv" do
    let!(:d1) { create(:donation, created_at: 2.years.ago) }
    let!(:d2) { create(:donation) }
    let(:data) do
      [
        %w[PEOPLE_ID ACCT_NAME DISPLAY_DATE AMOUNT DONATION_ID DESIGNATION MOTIVATION PAYMENT_METHOD MEMO
          TENDERED_AMOUNT TENDERED_CURRENCY ADJUSTMENT_TYPE],
        [d1.donor_account_id, d1.donor_account.name, d1.created_at.strftime("%m/%d/%Y"), d1.amount.to_s, d1.id,
          d1.designation_account_id, "", "", "", d1.amount.to_s, d1.currency, ""],
        [d2.donor_account_id, d2.donor_account.name, d2.created_at.strftime("%m/%d/%Y"), d2.amount.to_s, d2.id,
          d2.designation_account_id, "", "", "", d2.amount.to_s, d2.currency, ""]
      ]
    end

    it "returns csv" do
      expect(CSV.parse(described_class.as_csv)).to match_array(data)
    end
  end
end
