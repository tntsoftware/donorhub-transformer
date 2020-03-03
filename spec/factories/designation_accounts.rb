# frozen_string_literal: true

# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default("false")
#  balance    :decimal(, )      default("0")
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

FactoryBot.define do
  factory :designation_account do
  end
end
