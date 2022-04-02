# frozen_string_literal: true

class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members, id: :uuid do |t|
      t.belongs_to :organization, foreign_key: {on_delete: :cascade}, type: :uuid, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :access_token, null: false
      t.string :remote_id, unique: true

      t.timestamps
    end

    add_index :members, %i[email access_token], unique: true
  end
end
