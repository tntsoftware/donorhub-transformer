class CreateUserPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_permissions, id: :uuid do |t|
      t.belongs_to :user, type: :uuid, foreign_key: true
      t.belongs_to :designation_profile, type: :uuid, foreign_key: true

      t.timestamps
    end

    add_index :user_permissions,
              %i[designation_profile_id user_id],
              name: 'user_permissions_uniqueness_index',
              unique: true
  end
end
