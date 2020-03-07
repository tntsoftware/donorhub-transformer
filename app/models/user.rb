# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default("false")
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default("0"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  belongs_to :organization
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  validates_presence_of :email
  validates_uniqueness_of :email,
                          allow_blank: true,
                          case_sensitive: true,
                          scope: :organization_id,
                          if: :will_save_change_to_email?
  validates_format_of :email,
                      with: /\A[^@\s]+@[^@\s]+\z/,
                      allow_blank: true,
                      if: :will_save_change_to_email?
  validates_presence_of :password
  validates_confirmation_of :password
  validates_length_of :password, within: 6..128, allow_blank: true

  def self.find_for_authentication(conditions)
    joins(:organization).find_by(
      email: conditions[:email], organizations: { subdomain: conditions[:subdomain] }
    )
  end
end
