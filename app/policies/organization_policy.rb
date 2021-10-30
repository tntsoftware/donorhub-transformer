# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user&.has_role?(:member, record) || user&.has_role?(:admin, record)
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user&.has_role?(:admin, record)
  end

  def edit?
    update?
  end

  def destroy?
    user&.has_role?(:admin, record)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.with_roles(%i[admin member], user).distinct
    end
  end
end
