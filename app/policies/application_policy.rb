# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
   def error_message(action)
  case action
  when :index?
    "You cannot access the posts list."
  when :show?
    "You cannot view this post."
  when :create?, :new?
    "Only authors or admins can create posts."
  when :update?, :edit?
    "You can edit only your own post."
  when :destroy?
    "You are not allowed to delete this post."
  else
    "Unauthorized action."
  end
end



  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
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
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
