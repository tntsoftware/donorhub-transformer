# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id           :uuid             not null, primary key
#  access_token :string           not null
#  email        :string           not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  remote_id    :string
#
# Indexes
#
#  index_members_on_email_and_access_token  (email,access_token) UNIQUE
#

FactoryBot.define do
  factory :member do
    organization
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
