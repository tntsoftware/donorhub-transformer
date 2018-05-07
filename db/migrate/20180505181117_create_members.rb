class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :access_token, null: false
      t.string :remote_id, unique: true

      t.timestamps
    end

    add_index :members, %i[email access_token], unique: true
  end
end
