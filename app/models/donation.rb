# frozen_string_literal: true

# == Schema Information
#
# Table name: donations
#
#  id                     :uuid             not null, primary key
#  amount                 :decimal(, )
#  currency               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  designation_account_id :uuid             not null
#  donor_account_id       :uuid             not null
#  remote_id              :string
#
# Indexes
#
#  index_donations_on_designation_account_id  (designation_account_id)
#  index_donations_on_donor_account_id        (donor_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (designation_account_id => designation_accounts.id) ON DELETE => cascade
#  fk_rails_...  (donor_account_id => donor_accounts.id) ON DELETE => cascade
#

class Donation < ApplicationRecord
  include AsCsvConcern
  belongs_to :designation_account
  belongs_to :donor_account
  scope :by_date_range, lambda { |date_from, date_to|
    scope = all
    scope = scope.where('donations.created_at >= ?', date_from.beginning_of_day) unless date_from.blank?
    scope = scope.where('donations.created_at <= ?', date_to.end_of_day) unless date_to.blank?
    scope
  }
  validate :donor_account_and_designation_account_have_same_organization

  def as_csv
    {
      'PEOPLE_ID' => donor_account&.remote_id, 'ACCT_NAME' => donor_account&.name, 'DONATION_ID' => remote_id,
      'DESIGNATION' => designation_account&.remote_id, 'DISPLAY_DATE' => created_at&.strftime('%m/%d/%Y'),
      'AMOUNT' => amount, 'TENDERED_AMOUNT' => amount, 'TENDERED_CURRENCY' => currency, 'MOTIVATION' => '',
      'PAYMENT_METHOD' => '', 'MEMO' => '', 'ADJUSTMENT_TYPE' => ''
    }
  end

  protected

  def donor_account_and_designation_account_have_same_organization
    return if designation_account_id.nil? ||
              donor_account_id.nil? ||
              designation_account.organization_id == donor_account.organization_id

    errors.add(:designation_account_id, "can't be in different organization")
    errors.add(:donor_account_id, "can't be in different organization")
  end
end
