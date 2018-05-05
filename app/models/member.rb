class Member < ApplicationRecord
  validates :name, :email, :access_token, presence: true
end
