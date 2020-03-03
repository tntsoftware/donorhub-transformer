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
  has_many :donor_accounts, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :users, dependent: :destroy
end
