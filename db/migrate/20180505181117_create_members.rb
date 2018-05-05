class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :access_token, null: false, unique: true
      t.string :remote_id, unique: true

      t.timestamps
    end
  end
end
