class UserPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin? && user != record
  end

  def activate?
    user.admin? && !record.status?
  end

  def deactivate?
    user.admin? && record.status?
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.none
    end
  end
end
