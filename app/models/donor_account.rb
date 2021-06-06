# frozen_string_literal: true

# == Schema Information
#
# Table name: donor_accounts
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

class DonorAccount < ApplicationRecord
  has_many :donations, dependent: :destroy
  scope :by_date_range, lambda { |date_from, date_to|
    date_from = Time.zone.at(0) if date_from.blank?
    date_to = Time.zone.now if date_to.blank?
    where(created_at: date_from..date_to)
  }
  HEADERS = %w[
    PEOPLE_ID
    ACCT_NAME
  ].freeze

  def self.as_csv
    CSV.generate do |csv|
      csv << HEADERS
      order(created_at: :desc).find_each do |donor_account|
        csv << [
          donor_account.id, donor_account.name
        ]
      end
    end
  end
end
