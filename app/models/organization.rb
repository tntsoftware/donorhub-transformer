# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id         :uuid             not null, primary key
#  code       :string
#  email      :string
#  name       :string
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_subdomain  (subdomain) UNIQUE
#
class Organization < ApplicationRecord
  has_many :designation_accounts, dependent: :destroy
  has_many :donations, through: :designation_accounts
  has_many :donor_accounts, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :users, dependent: :destroy
  validates :subdomain, presence: true, format: { with: /\A([a-z][a-z\d]*(-[a-z\d]+)*|xn--[\-a-z\d]+)\z/i }
  after_commit :update_subdomain

  def minimum_donation_date
    (donations.minimum(:created_at) || Time.at(0)).strftime('%m/%d/%Y')
  end

  protected

  def update_subdomain
    return unless !Rails.env.development? && (new_record? || saved_change_to_subdomain?)

    if subdomain_before_last_save.present?
      Organization::SubdomainJob.perform_later(subdomain_before_last_save, 'remove')
    end
    Organization::SubdomainJob.perform_later(subdomain, 'add')
  end
end
