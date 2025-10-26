module ApplicationHelper
  def header_cart_count
    if user_signed_in?
      current_user.cart&.total_quantity || 0
    else
      SessionCart.new(session).total_quantity
    end
  end
end
