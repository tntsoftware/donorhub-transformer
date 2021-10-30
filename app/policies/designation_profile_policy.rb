# frozen_string_literal: true

class DesignationProfilePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.has_role?(:admin, record.organization) || record.member.user == user
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
      if user.has_role?(:admin, organization)
        scope.all
      else
        scope.joins(member: :user)
             .where(users: { id: user.id })
             .distinct
      end
    end

    def organization
      @organization ||= scope.instance_variable_get(:@association).instance_variable_get(:@owner)
    end
  end
end
