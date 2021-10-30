# frozen_string_literal: true

class IntegrationPolicy < ApplicationPolicy
  def index?
    user.has_role?(:admin, record.organization)
  end

  def show?
    user.has_role?(:admin, record.organization)
  end

  def create?
    user.has_role?(:admin, record.organization)
  end

  def new?
    create?
  end

  def update?
    user.has_role?(:admin, record.organization)
  end

  def edit?
    update?
  end

  def destroy?
    user.has_role?(:admin, record.organization)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.has_role?(:admin, organization)
        scope.all
      else
        scope.none
      end
    end

    def organization
      @organization ||= scope.instance_variable_get(:@association).instance_variable_get(:@owner)
    end
  end
end
