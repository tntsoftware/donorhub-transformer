class User < ApplicationRecord
  acts_as_token_authenticatable

  has_many :permissions, class_name: 'User::Permission', dependent: :destroy
  has_many :designation_profiles, through: :permissions
  has_many :designation_accounts, through: :designation_profiles
  has_many :donations, through: :designation_profiles
  has_many :donor_accounts, through: :designation_profiles

  enum role: %i[user vip admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def name
    super || email
  end
end
