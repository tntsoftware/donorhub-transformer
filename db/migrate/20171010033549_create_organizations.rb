# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :abbreviation
      t.string :account_help_url
      t.string :request_profile_url
      t.string :help_url
      t.string :help_description
      t.string :currency_code
      t.string :subdomain, null: false, unique: true

      t.timestamps
    end
  end
end
