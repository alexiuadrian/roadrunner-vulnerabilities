class RunPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.has_role? :admin
        scope.all
      else
        scope.where(user_id: @user.id)
      end

    end
  end

  def index?
    @user.has_any_role? :admin, :user
  end

  def create?
    @user.has_any_role? :admin, :user
  end

  def edit?
    @user.has_any_role? :admin, :user
  end

  def update?
    @user.has_any_role? :admin, :user
  end

  def show?
    @user.has_any_role? :admin, :user
  end

  def destroy?
    @user.has_any_role? :admin, :user
  end

  def report?
    @user.has_any_role? :admin, :user
  end
end
