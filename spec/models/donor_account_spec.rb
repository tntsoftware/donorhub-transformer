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

require 'rails_helper'

RSpec.describe DonorAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
