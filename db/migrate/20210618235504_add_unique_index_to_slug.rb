# frozen_string_literal: true

class AddUniqueIndexToSlug < ActiveRecord::Migration[6.1]
  def change
    add_index :organizations, :slug, unique: true
  end
end
