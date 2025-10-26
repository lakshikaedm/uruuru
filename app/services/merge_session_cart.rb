class MergeSessionCart
  def initialize(session:, user:)
    @session = session
    @user = user
  end

  def call
    data = SessionCart.new(@session).raw_data
    return if data.blank?

    cart = @user.cart || @user.create_cart!
    data.each do |pid, qty|
      next if qty.to_i <= 0

      cart.add(pid, qty.to_i)
    end

    # clear session cart after merge
    @session[SessionCart::SESSION_KEY] = {}
  end
end
