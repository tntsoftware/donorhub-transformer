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
  include AsCsvConcern
  belongs_to :organization
  has_many :donations, dependent: :destroy
  scope :by_date_range, lambda { |date_from, date_to|
    scope = all
    scope = scope.where('donor_accounts.updated_at >= ?', date_from.beginning_of_day) unless date_from.blank?
    scope = scope.where('donor_accounts.updated_at <= ?', date_to.end_of_day) unless date_to.blank?
    scope
  }

  def as_csv
    {
      'PEOPLE_ID' => remote_id,
      'ACCT_NAME' => name
    }
  end
end
