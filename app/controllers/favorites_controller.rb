class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[create destroy]

  def index
    @products =
      Product.joins(:favorites)
             .where(favorites: { user_id: current_user.id })
             .with_attached_images
             .order('favorites.created_at DESC')
  end

  def create
    current_user.favorites.find_or_create_by!(product: @product)
    @product.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: product_path(@product), notice: t(".added") }
    end
  end

  def destroy
    current_user.favorites.find_by!(product: @product)&.destroy
    @product.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: product_path(@product), notice: t(".removed") }
    end
  end

  private

  def set_product
    return if params[:product_id].blank?

    @product = Product.find(params[:product_id])
  end
end
