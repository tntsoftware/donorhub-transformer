class CreateDesignationProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :designation_profiles, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
