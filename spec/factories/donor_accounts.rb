# == Schema Information
#
# Table name: donor_accounts
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

FactoryBot.define do
  factory :donor_account do
    name "MyString"
    is_supplier false
    is_customer false
  end
end
