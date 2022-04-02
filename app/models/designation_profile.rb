# frozen_string_literal: true

class DesignationProfile < ApplicationRecord
  multi_tenant :organization
  belongs_to :designation_account
  belongs_to :member
  has_many :donor_accounts, through: :designation_account
  has_many :donations, through: :designation_account
  validates :designation_account_id, uniqueness: {scope: :member_id}
  HEADERS = %w[
    PROFILE_CODE
    PROFILE_DESCRIPTION
    PROFILE_ACCOUNT_REPORT_URL
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
      find_each do |designation_profile|
        csv << [designation_profile.id, designation_profile.name, ""]
      end
    end
  end

  def self.balances_as_csv
    CSV.generate do |csv|
      csv << BALANCE_HEADERS
      find_each do |designation_profile|
        csv << [
          designation_profile.designation_account.id, designation_profile.designation_account.name,
          designation_profile.designation_account.balance, designation_profile.id, designation_profile.name, ""
        ]
      end
    end
  end

  def name
    "#{designation_account.name} | #{member.name}"
  end
end
