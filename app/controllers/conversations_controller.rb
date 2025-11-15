class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: :show
  before_action :ensure_participating!, only: :show

  def index
    @conversations = current_user.conversations.includes(:product)
  end

  def show; end

  def create
    participant = User.find_by(id: params[:participant_id])
    product     = Product.find_by(id: params[:product_id])

    return render :new, status: :unprocessable_content unless participant && product

    seller = product.user
    buyer  = current_user == seller ? participant : current_user

    @conversation = Conversation.find_by(
      product: product,
      buyer: buyer,
      seller: seller
    )

    unless @conversation
      @conversation = Conversation.new(
        product: product,
        buyer: buyer,
        seller: seller
      )

      @conversation.participants << buyer
      @conversation.participants << seller

      return render :new, status: :unprocessable_content unless @conversation.save
    end

    redirect_to @conversation
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def ensure_participating!
    return if @conversation.participants.include?(current_user)

    raise ActiveRecord::RecordNotFound
  end
end
