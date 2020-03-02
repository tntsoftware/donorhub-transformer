# frozen_string_literal: true

FactoryBot.define do
  factory :designation_profile_permission, class: 'DesignationProfile::Permission' do
    designation_profile { nil }
    designation_account { nil }
  end
end
