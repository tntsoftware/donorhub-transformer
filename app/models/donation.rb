# frozen_string_literal: true

class Donation < ApplicationRecord
  multi_tenant :organization
  belongs_to :designation_account
  belongs_to :donor_account
  scope :by_date_range, lambda { |date_from, date_to|
    date_from = Time.zone.at(0) if date_from.blank?
    date_to = Time.zone.now if date_to.blank?
    where(updated_at: date_from..date_to)
  }
  HEADERS = %w[
    PEOPLE_ID
    ACCT_NAME
    DISPLAY_DATE
    AMOUNT
    DONATION_ID
    DESIGNATION
    MOTIVATION
    PAYMENT_METHOD
    MEMO
    TENDERED_AMOUNT
    TENDERED_CURRENCY
    ADJUSTMENT_TYPE
  ].freeze

  def self.as_csv
    CSV.generate do |csv|
      csv << HEADERS
      find_each do |donation|
        csv << [
          donation.donor_account_id, donation.donor_account.name, donation.created_at.strftime("%m/%d/%Y"),
          donation.amount, donation.id, donation.designation_account_id, "", "", "", donation.amount, donation.currency,
          ""
        ]
      end
    end
  end
end
