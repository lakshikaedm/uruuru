module ApplicationHelper
  def header_cart_count
    if user_signed_in?
      current_user.cart&.total_quantity || 0
    else
      SessionCart.new(session).total_quantity
    end
  end

  def field_state_classes(record, attribute)
    if record.errors[attribute].any?
      "border-red-400 focus:outline-red-600"
    else
      "border-gray-400 focus:outline-blue-600"
    end
  end
end
