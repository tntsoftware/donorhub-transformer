# frozen_string_literal: true

FactoryBot.define do
  factory :designation_account do
    name { Faker::Name.name }
  end
end
