# frozen_string_literal: true

# == Schema Information
#
# Table name: donations
#
#  id                     :uuid             not null, primary key
#  amount                 :decimal(, )
#  currency               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  designation_account_id :uuid             not null
#  donor_account_id       :uuid             not null
#  remote_id              :string
#
# Indexes
#
#  index_donations_on_designation_account_id  (designation_account_id)
#  index_donations_on_donor_account_id        (donor_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (designation_account_id => designation_accounts.id) ON DELETE => cascade
#  fk_rails_...  (donor_account_id => donor_accounts.id) ON DELETE => cascade
#

FactoryBot.define do
  factory :donation do
    designation_account
    donor_account
    amount { '9.99' }
    currency { 'NZD' }
  end
end
