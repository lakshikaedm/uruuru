module FavoritesHelper
  def favorited?(product)
    user_signed_in? && current_user.favorite_products.exists?(product.id)
  end
end
