class PizzaPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.owner?
        scope.all
      elsif user.chef?
        scope.where(chef: user)
      else
        scope.none
      end
    end
  end

  def show?
    user.chef?
  end

  def create?
    user.chef?
  end

  def update?
    user.chef?
  end

  def destroy?
    user.chef?
  end
end
