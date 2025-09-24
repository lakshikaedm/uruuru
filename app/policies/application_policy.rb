# Base Pundit policy for the app.
# Holds the current user and record and provides default allow/deny behavior.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?  = true
  def show?   = true

  def create? = false
  def new?    = create?
  def update? = false
  def edit?   = update?
  def destroy? = false

  # Default scope used by Pundit to determine which records are visible.
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
