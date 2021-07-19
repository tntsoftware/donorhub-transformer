# frozen_string_literal: true

class Member < ApplicationRecord
  multi_tenant :organization
  has_many :designation_profiles, dependent: :destroy
  has_many :designation_accounts, through: :designation_profiles
  has_many :donations, through: :designation_accounts
  has_many :donor_accounts, through: :donations
  belongs_to :user
  validates :access_token, presence: true, uniqueness: true
  validates :user_id, uniqueness: { scope: :organization_id }
  before_validation :create_access_token, on: :create
  after_commit :send_inform_email, on: :create
  delegate :email, to: :user
  
  def send_inform_email
    MemberMailer.inform(self).deliver_later
  end

  protected

  def create_access_token
    self.access_token ||= loop do
      access_token = SecureRandom.base58(24)
      break access_token unless self.class.exists?(access_token: access_token)
    end
  end
end
