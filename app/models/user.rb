# frozen_string_literal: true

class User < ApplicationRecord
  multi_tenant :organization
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
