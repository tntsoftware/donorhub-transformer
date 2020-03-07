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

  class << self
    def balances_as_csv(designation_profile = nil)
      CSV.generate do |csv|
        hash = all_as_csv.merge(designation_profile_as_csv(designation_profile))
        csv << hash.keys
        csv << hash.values
      end
    end

    private

    def all_as_csv
      {
        'EMPLID' => all.map(&:remote_id).join(','),
        'ACCT_NAME' => all.map(&:name).join(','),
        'BALANCE' => all.map(&:balance).join(',')
      }
    end

    def designation_profile_as_csv(designation_profile)
      {
        'PROFILE_CODE' => designation_profile&.remote_id || designation_profile&.id || '',
        'PROFILE_DESCRIPTION' => designation_profile&.name || '',
        'FUND_ACCOUNT_REPORT_URL' => ''
      }
    end
  end

  def as_csv
    {
      'DESIG_ID' => remote_id,
      'DESIG_NAME' => name,
      'ORG_PATH' => ''
    }
  end
end
