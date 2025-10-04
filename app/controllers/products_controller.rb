class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @products = Product.search(params[:q])
                       .by_category(params[:category_id])
                       .by_status(params[:status])
                       .order(created_at: :desc)
  end

  def show
  end

  def new
    @product = Product.new
    authorize @product
  end

  def edit
    authorize @product
  end

  def create
    attrs = product_params.to_h
    files = attrs.delete("images") || []
    files = Array.wrap(files).compact_blank
    @product = current_user.products.build(attrs)
    authorize @product
    if @product.save
      files.each { |f| @product.images.attach(f) } if files.present?
      redirect_to @product, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    attrs = product_params.to_h
    files = attrs.delete("images") || []
    files = Array.wrap(files).compact_blank
    respond_to do |format|
      if @product.update(attrs)
        files.each { |f| @product.images.attach(f) } if files.present?
        format.html { redirect_to @product, notice: t('.updated'), status: :see_other }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @product
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, notice: t('.destroyed'), status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def authorize_owner!
      redirect_to @product, alert: t('products.not_authorized') unless @product.user_id == current_user&.id
    end

    def product_params
      permitted = params.require(:product).permit(
        :title, :description, :price, :status, :category_id, 
        images: []
        )
      if permitted[:images].is_a?(Array)
        permitted[:images].compact!
        permitted[:images].reject!(&:blank?)

        permitted.delete(:images) if permitted[:images].empty?
      end

      permitted
    end
end
