class User
  class Permission < ApplicationRecord
    belongs_to :user
    belongs_to :designation_profile
    validates :user_id, uniqueness: { scope: :designation_profile_id }
  end
end
