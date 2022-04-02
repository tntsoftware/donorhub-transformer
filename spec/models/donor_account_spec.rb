# frozen_string_literal: true

require "rails_helper"

RSpec.describe DonorAccount, type: :model do
  subject(:donor_account) { create(:donor_account) }

  it { is_expected.to have_many(:donations).dependent(:destroy) }

  describe ".by_date_range" do
    let!(:old_donor_account) { create(:donor_account, updated_at: 2.years.ago) }
    let!(:new_donor_account) { create(:donor_account) }

    it "returns all donor_accounts" do
      expect(described_class.by_date_range(nil, nil)).to match_array([old_donor_account, new_donor_account])
    end

    it "returns new donor_account when date_from" do
      expect(described_class.by_date_range(1.year.ago, nil)).to match_array([new_donor_account])
    end

    it "returns old donor_account when date_to" do
      expect(described_class.by_date_range(nil, 1.year.ago)).to match_array([old_donor_account])
    end

    it "returns old donor_account when date_from and date_to" do
      expect(described_class.by_date_range(3.years.ago, 1.year.ago)).to match_array([old_donor_account])
    end
  end

  describe ".as_csv" do
    let!(:donor_account1) { create(:donor_account, created_at: 2.years.ago) }
    let!(:donor_account2) { create(:donor_account) }
    let(:data) do
      [
        %w[PEOPLE_ID ACCT_NAME],
        [donor_account1.id, donor_account1.name],
        [donor_account2.id, donor_account2.name]
      ]
    end

    it "returns csv" do
      expect(CSV.parse(described_class.as_csv)).to match_array(data)
    end
  end
end
