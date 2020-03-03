# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    organization { nil }
    encrypted_access_token { 'MyString' }
    encrypted_access_token_iv { 'MyString' }
    encrypted_refresh_token { 'MyString' }
    encrypted_refresh_token_iv { 'MyString' }
  end
end
