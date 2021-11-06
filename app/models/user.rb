# frozen_string_literal: true

class User < ApplicationRecord
  rolify after_add: :after_add_role, after_remove: :after_remove_role
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable
  has_many :members, dependent: :destroy
  has_many :organizations, through: :members

  protected

  def after_add_role(role)
    organizations << role.resource if role.resource.is_a?(Organization) && role.name == 'member'
  end

  def after_remove_role(role)
    return unless role.resource.is_a?(Organization) && role.name == 'member'

    members.find_by(organization_id: role.resource)&.destroy
  end
end
