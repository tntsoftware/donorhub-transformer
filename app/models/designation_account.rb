# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

class DesignationAccount < ApplicationRecord
  has_many :designation_profiles, dependent: :destroy
  has_many :donations, dependent: :destroy
  has_many :donor_accounts, through: :donations
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def self.as_csv
    CSV.generate do |csv|
      headers = %w(
        DESIG_ID
        DESIG_NAME
        ORG_PATH
      )

      csv << headers

      all.each do |designation_account|
        csv << [
          designation_account.id,   # DESIG_ID
          designation_account.name, # DESIG_NAME
          "",                       # ORG_PATH
        ]
      end
    end
  end
end
