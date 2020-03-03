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
  belongs_to :organization
  has_many :donations, dependent: :destroy
  scope :by_date_range, lambda { |date_from, date_to|
    scope = all
    scope = scope.where('donor_accounts.updated_at >= ?', date_from.beginning_of_day) unless date_from.blank?
    scope = scope.where('donor_accounts.updated_at <= ?', date_to.end_of_day) unless date_to.blank?
    scope
  }

  def self.as_csv
    CSV.generate do |csv|
      headers = %w[
        PEOPLE_ID
        ACCT_NAME
      ]

      csv << headers

      all.each do |donor_account|
        csv << [
          donor_account.id,  # PEOPLE_ID
          donor_account.name # ACCT_NAME
        ]
      end
    end
  end
end
