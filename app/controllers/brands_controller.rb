class BrandsController < ApplicationController
  def index
    @brands = Brand.order(:name)
  end

  def show
    @brand = Brand.find(params[:id])
    @products = @brand.products
                      .includes(:brand, :user)
                      .order(created_at: :desc)
  end
end
