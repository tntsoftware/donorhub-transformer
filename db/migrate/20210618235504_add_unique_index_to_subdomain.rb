# frozen_string_literal: true

class AddUniqueIndexToSubdomain < ActiveRecord::Migration[6.1]
  def change
    add_index :organizations, :subdomain, unique: true
  end
end
