class DonorAccount < ApplicationRecord
  has_many :donations, dependent: :destroy
  scope :by_date_range, lambda { |date_from, date_to|
    date_from = Time.zone.at(0) if date_from.blank?
    date_to = Time.zone.now if date_to.blank?
    where(created_at: date_from..date_to)
  }
end
