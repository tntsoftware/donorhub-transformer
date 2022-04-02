# frozen_string_literal: true

FactoryBot.define do
  factory :donation do
    designation_account
    donor_account
    amount { "9.99" }
    currency { "NZD" }
  end
end
