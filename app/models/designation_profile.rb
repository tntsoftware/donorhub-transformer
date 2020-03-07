# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_profiles
#
#  id                     :uuid             not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  designation_account_id :uuid             not null
#  member_id              :uuid             not null
#  remote_id              :string
#
# Indexes
#
#  index_designation_profiles_on_designation_account_id  (designation_account_id)
#  index_designation_profiles_on_member_id               (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (designation_account_id => designation_accounts.id) ON DELETE => cascade
#  fk_rails_...  (member_id => members.id) ON DELETE => cascade
#

class DesignationProfile < ApplicationRecord
  include AsCsvConcern
  belongs_to :designation_account
  belongs_to :member
  has_many :donor_accounts, through: :designation_account
  has_many :donations, through: :designation_account
  validate :member_and_designation_account_have_same_organization

  def as_csv
    {
      'PROFILE_CODE' => remote_id || id,
      'PROFILE_DESCRIPTION' => name,
      'PROFILE_ACCOUNT_REPORT_URL' => ''
    }
  end

  def name
    "#{designation_account&.name} | #{member&.name}"
  end

  protected

  def member_and_designation_account_have_same_organization
    return if designation_account&.organization_id == member&.organization_id

    errors.add(:designation_account_id, "can't be in different organization")
    errors.add(:member_id, "can't be in different organization")
  end
end
