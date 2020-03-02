# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(FALSE)
#  balance    :decimal(, )      default(0.0)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

class DesignationAccount < ApplicationRecord
  has_many :designation_profiles, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :donor_accounts, through: :donations
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.as_csv
    CSV.generate do |csv|
      headers = %w[
        DESIG_ID
        DESIG_NAME
        ORG_PATH
      ]

      csv << headers

      all.each do |designation_account|
        csv << [
          designation_account.id,   # DESIG_ID
          designation_account.name, # DESIG_NAME
          ''                        # ORG_PATH
        ]
      end
    end
  end

  def self.balances_as_csv(designation_profile)
    CSV.generate do |csv|
      headers = %w[
        EMPLID
        ACCT_NAME
        BALANCE
        PROFILE_CODE
        PROFILE_DESCRIPTION
        FUND_ACCOUNT_REPORT_URL
      ]

      csv << headers

      designation_accounts = all

      csv << [
        designation_accounts.map(&:id).join(','),      # EMPLID
        designation_accounts.map(&:name).join(','),    # ACCT_NAME
        designation_accounts.map(&:balance).join(','), # BALANCE
        designation_profile.id,                        # PROFILE_CODE
        designation_profile.name,                      # PROFILE_DESCRIPTION
        ''                                             # FUND_ACCOUNT_REPORT_URL
      ]
    end
  end
end
