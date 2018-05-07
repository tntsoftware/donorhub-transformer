class Member < ApplicationRecord
  has_many :designation_profiles, dependent: :destroy
  has_many :designation_accounts, through: :designation_profiles
  has_many :donations, through: :designation_accounts
  has_many :donor_accounts, through: :donations
  validates :name, :email, :access_token, presence: true
  before_validation :create_access_token, on: :create

  protected

  def create_access_token
    self.access_token = SecureRandom.base58(24)
  end
end
