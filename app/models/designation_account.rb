# frozen_string_literal: true

class DesignationAccount < ApplicationRecord
  has_many :designation_profiles, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :donor_accounts, through: :donations
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  HEADERS = %w[
    DESIG_ID
    DESIG_NAME
    ORG_PATH
  ].freeze

  def self.as_csv
    CSV.generate do |csv|
      csv << HEADERS
      find_each do |designation_account|
        csv << [designation_account.id, designation_account.name, '']
      end
    end
  end
end
