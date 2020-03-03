# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[6.0]
  class Organization < ApplicationRecord; end
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name
      t.string :subdomain
      t.string :code
      t.string :email

      t.timestamps
    end
    add_index :organizations, :subdomain, unique: true
    return if Rails.env.test?

    Organization.create(
      name: ENV['ORG_NAME'],
      code: ENV['ORG_CODE'],
      subdomain: ENV['ORG_CODE'].downcase,
      email: ENV['ORG_CONTACT_EMAIL']
    )
  end
end
