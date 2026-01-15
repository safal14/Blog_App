class PostPolicy < ApplicationPolicy
  class Scope < Scope
 def resolve
      if user&.admin?
        scope.all                                 # admins see everything
      elsif user.present? && (user.author? || user.reader?)
        # Authors see: own drafts + all published
        # Readers see: only published
        scope.where(user: user).or(scope.published)
      else
        # Guests (not logged in) see only published
        scope.published
      end
    end
  end
  def index?
    true        # anyone can see the list
  end

def show?
  record.published? || record.user == user || user&.admin?
 # anyone can view a single post
  end

  def create?
    user.present?  && (user.author? || user.admin?) # must be logged in and must be author or admin
  end

  def new?
    create?
  end

  def update?
    user.present? && (record.user == user || user.admin?)
  end

  def edit?
    update?
  end

  def destroy?
    update?     # same rules as update
  end
end