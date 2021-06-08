# frozen_string_literal: true

FactoryBot.define do
  factory :donor_account do
    name { Faker::Name.name }
  end
end
