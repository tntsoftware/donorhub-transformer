# frozen_string_literal: true

class DonorAccountPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.has_role?(:admin, record.organization) || user.donor_accounts.include?(record)
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
        scope.where(users: [user])
      end
    end

    def organization
      @organization ||= scope.instance_variable_get(:@association).instance_variable_get(:@owner)
    end
  end
end
