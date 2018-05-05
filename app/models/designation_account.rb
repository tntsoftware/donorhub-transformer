class DesignationAccount < ApplicationRecord
  has_many :designation_profiles, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :donor_accounts, through: :donations
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
