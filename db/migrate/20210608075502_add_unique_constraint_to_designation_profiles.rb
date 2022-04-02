# frozen_string_literal: true

class AddUniqueConstraintToDesignationProfiles < ActiveRecord::Migration[6.1]
  def change
    add_index :designation_profiles, %i[designation_account_id member_id], unique: true,
                                                                           name: "idx_uniq_da_id_and_member_id"
  end
end
