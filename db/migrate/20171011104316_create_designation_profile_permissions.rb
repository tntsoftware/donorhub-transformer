class CreateDesignationProfilePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :designation_profile_permissions, id: :uuid do |t|
      t.belongs_to :designation_profile, type: :uuid, foreign_key: true
      t.belongs_to :designation_account, type: :uuid, foreign_key: true

      t.timestamps
    end

    add_index :designation_profile_permissions,
              %i[designation_profile_id designation_account_id],
              name: 'designation_profile_permissions_uniqueness_index',
              unique: true
  end
end
