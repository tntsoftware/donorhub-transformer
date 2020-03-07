# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default("false")
#  balance    :decimal(, )      default("0")
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

class DesignationAccount < ApplicationRecord
  include AsCsvConcern
  belongs_to :organization
  has_many :designation_profiles, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :donor_accounts, through: :donations
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def as_csv
    {
      'DESIG_ID' => remote_id,
      'DESIG_NAME' => name,
      'ORG_PATH' => ''
    }
  end

  def self.balances_as_csv(designation_profile = nil)
    CSV.generate do |csv|
      csv << %w[EMPLID ACCT_NAME BALANCE PROFILE_CODE PROFILE_DESCRIPTION FUND_ACCOUNT_REPORT_URL]
      csv << [
        all.map(&:remote_id).join(','),  # EMPLID
        all.map(&:name).join(','),       # ACCT_NAME
        all.map(&:balance).join(','),    # BALANCE
        designation_profile&.remote_id || designation_profile&.id || '', # PROFILE_CODE
        designation_profile&.name || '', # PROFILE_DESCRIPTION
        ''                               # FUND_ACCOUNT_REPORT_URL
      ]
    end
  end
end
