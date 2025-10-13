class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    current_user.favorites.find_or_create_by!(product: @product)
    @product.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: product_path(@product), notice: "Added to favorites" }
    end
  end

  def destroy
    current_user.favorites.find_by!(product: @product)&.destroy
    @product.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: product_path(@product), notice: "Removed from favorites" }
    end
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end
end
    