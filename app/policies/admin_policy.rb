class AdminPolicy < ApplicationPolicy
  def initialize(user, _record)
    @user = user
  end

  def manage_users?
    user&.admin?
  end
end
