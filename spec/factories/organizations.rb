# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    subdomain { Faker::Internet.unique.domain_word }
    code { Faker::Company.ein }
    name { Faker::Company.name }
    abbreviation { Faker::Company.suffix }
    account_help_url { Faker::Internet.url }
    request_profile_url { Faker::Internet.url }
    help_url { Faker::Internet.url }
    help_description { Faker::Hipster.paragraph }
    currency_code { Faker::Currency.code }
  end
end
