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
  belongs_to :designation_account
  belongs_to :member

  def name
    "#{designation_account.name} | #{member.name}"
  end
end
