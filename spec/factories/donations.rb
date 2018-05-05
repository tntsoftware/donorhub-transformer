FactoryGirl.define do
  factory :donation do
    designation_account nil
    description 'MyString'
    net_amount '9.99'
    gross_amount '9.99'
    tax_amount '9.99'
  end
end
