class DesignationAccount < ApplicationRecord
  has_many :permissions, dependent: :destroy
  has_many :designation_profiles, through: :permissions
  has_many :donations, dependent: :destroy
  has_many :donor_accounts, through: :donations
  scope :active, -> { where(status: 'ACTIVE', sync_donations: true) }
  scope :inactive, -> { where(sync_donations: false) }
end
