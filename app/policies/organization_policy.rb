# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.organizations.exists?(id: record.id)
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    true
  end
end
