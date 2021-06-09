# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :donor_accounts, dependent: :destroy
  has_many :designation_accounts, dependent: :destroy
  validates :code, :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
end
