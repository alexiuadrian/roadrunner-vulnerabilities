class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_any_role? :admin, :user_manager
  end

  def show?
    @user.has_any_role? :admin, :user_manager
  end

  def update?
    @user.has_any_role? :admin, :user_manager
  end

  def destroy?
    @user.has_any_role? :admin, :user_manager
  end

  def user_roles?
    @user.has_any_role? :admin, :user_manager
  end

  def get_user_roles?
    @user.has_any_role? :admin, :user_manager
  end

end
