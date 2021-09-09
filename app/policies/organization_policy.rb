# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user&.has_role?(:member, record) || user&.has_role?(:admin, record)
  end

  def create?
    user.present?
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
      return scope.none unless user

      scope.with_roles(%i[admin member], user).distinct
    end
  end
end
