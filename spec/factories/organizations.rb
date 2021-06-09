# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    subdomain { Faker::Internet.unique.domain_word }
    code { 'MyString' }
    name { 'MyString' }
    abbreviation { 'MyString' }
    account_help_url { 'MyString' }
    request_profile_url { 'MyString' }
    help_url { 'MyString' }
    help_description { 'MyString' }
    currency_code { 'MyString' }
  end
end
