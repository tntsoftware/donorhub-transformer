# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id           :uuid             not null, primary key
#  access_token :string           not null
#  email        :string           not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  remote_id    :string
#
# Indexes
#
#  index_members_on_email_and_access_token  (email,access_token) UNIQUE
#

class Member < ApplicationRecord
  has_many :designation_profiles, dependent: :destroy
  has_many :designation_accounts, through: :designation_profiles
  has_many :donations, through: :designation_accounts
  has_many :donor_accounts, through: :donations
  validates :name, :email, presence: true
  before_create :create_access_token
  after_commit :send_inform_email, on: :create

  protected

  def send_inform_email
    MemberMailer.inform(self).deliver_now
  end

  def create_access_token
    self.access_token = SecureRandom.base58(24)
  end
end
