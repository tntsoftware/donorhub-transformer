# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable
  has_many :members, dependent: :destroy
  has_many :organizations, through: :members
end
