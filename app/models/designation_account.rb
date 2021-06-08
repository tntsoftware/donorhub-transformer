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
  HEADERS = %w[
    DESIG_ID
    DESIG_NAME
    ORG_PATH
  ].freeze
  BALANCE_HEADERS = %w[
    EMPLID
    ACCT_NAME
    BALANCE
    PROFILE_CODE
    PROFILE_DESCRIPTION
    FUND_ACCOUNT_REPORT_URL
  ].freeze

  def self.as_csv
    CSV.generate do |csv|
      csv << HEADERS
      find_each do |designation_account|
        csv << [designation_account.id, designation_account.name, '']
      end
    end
  end

  def self.balances_as_csv(designation_profile)
    CSV.generate do |csv|
      csv << BALANCE_HEADERS
      designation_accounts = order(created_at: :desc)
      csv << [
        designation_accounts.map(&:id).join(','), designation_accounts.map(&:name).join(','),
        designation_accounts.map(&:balance).join(','), designation_profile.id, designation_profile.name, ''
      ]
    end
  end
end
