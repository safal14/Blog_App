class UserPolicy < ApplicationPolicy
  # Who can see the list of all users? → only admins
  def index?
    user.admin?   # ← adjust this line if your admin check is different (see note below)
  end

  def show?
    user.admin? || (user == record)   # admin or looking at own profile
  end

  def create?
    user.admin?
  end

  def new?
    create?   # same as create
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? && (user != record)   # admins can delete others, not themselves
  end

  # Custom actions for activate / deactivate
  def activate?
    user.admin? && !record.status?    # admin + user is currently inactive
  end

  def deactivate?
    user.admin? && record.status?     # admin + user is currently active
  end
  def destroy?
  user.admin? && record != user   # admin can delete others, but not himself
  end
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all                       # admins see everyone
      else
        scope.where(id: user.id)        # normal users only see themselves
      end
    end
  end
end