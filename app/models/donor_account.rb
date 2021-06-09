# frozen_string_literal: true

class DonorAccount < ApplicationRecord
  multi_tenant :organization
  has_many :donations, dependent: :destroy
  scope :by_date_range, lambda { |date_from, date_to|
    date_from = Time.zone.at(0) if date_from.blank?
    date_to = Time.zone.now if date_to.blank?
    where(updated_at: date_from..date_to)
  }
  HEADERS = %w[
    PEOPLE_ID
    ACCT_NAME
  ].freeze

  def self.as_csv
    CSV.generate do |csv|
      csv << HEADERS
      find_each do |donor_account|
        csv << [
          donor_account.id, donor_account.name
        ]
      end
    end
  end
end
