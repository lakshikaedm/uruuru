# Authorization rules for Product:
# Anyone can read; only the owner can update/destroy; any logged-in user can create.
class ProductPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && record.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def show?
    true
  end

  def index?
    true
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
