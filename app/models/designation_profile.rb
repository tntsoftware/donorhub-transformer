class DesignationProfile < ApplicationRecord
  has_many :permissions, dependent: :destroy, class_name: 'DesignationProfile::Permission'
  has_many :user_permissions, dependent: :destroy, class_name: 'User::Permission'
  has_many :designation_accounts, through: :permissions
  has_many :donations, through: :designation_accounts
  has_many :donor_accounts, through: :designation_accounts
  validates :name, presence: true
end
