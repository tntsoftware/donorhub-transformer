class DesignationProfile < ApplicationRecord
  belongs_to :designation_account
  belongs_to :member

  def name
    "#{designation_account.name} | #{member.name}"
  end
end
