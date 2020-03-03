# == Schema Information
#
# Table name: organizations
#
#  id         :uuid             not null, primary key
#  code       :string
#  email      :string
#  name       :string
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_subdomain  (subdomain) UNIQUE
#
FactoryBot.define do
  factory :organization do
    name { "MyString" }
    subdomain { "MyString" }
    code { "MyString" }
    contact_email { "MyString" }
  end
end
