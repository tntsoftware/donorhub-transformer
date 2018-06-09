# == Schema Information
#
# Table name: designation_accounts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  remote_id  :string
#

require "rails_helper"

RSpec.describe DesignationAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
