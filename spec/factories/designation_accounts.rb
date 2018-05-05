FactoryGirl.define do
  factory :designation_account do
    account_id 'MyString'
    code 'MyString'
    name 'MyString'
    status 'MyString'
    type ''
    tax_type 'MyString'
    description 'MyString'
    klass 'MyString'
    enable_payments_to_account false
    show_in_expense_claims false
    reporting_code 'MyString'
    reporting_code_name 'MyString'
    sync_journal_line_items false
  end
end
