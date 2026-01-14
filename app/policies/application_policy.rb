class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all   # everyone can see all posts
    end
  end

  def index?
    true        # anyone can see the list
  end

  def show?
    true        # anyone can view a single post
  end

  def create?
    user.present?   # must be logged in
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