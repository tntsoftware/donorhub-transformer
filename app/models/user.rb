# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :members, dependent: :destroy
  has_many :organizations, through: :members
end
