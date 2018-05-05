class DesignationProfile
  class Permission < ApplicationRecord
    belongs_to :designation_profile
    belongs_to :designation_account
    validates :designation_profile_id, uniqueness: { scope: :designation_account_id }
  end
end
