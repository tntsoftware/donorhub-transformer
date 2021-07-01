# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :donor_accounts, dependent: :destroy
  has_many :donations, through: :donor_accounts
  has_many :designation_accounts, dependent: :destroy
  has_many :integrations, dependent: :destroy
  has_many :xero_integrations, class_name: 'Integration::Xero', dependent: :destroy
  validates :code, :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
