class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :ensure_participant!

  def create
    @message      = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to conversation_path(@conversation)
    else
      @messages = @conversation.messages.includes(:user)
      flash.now[:alert] = t("messages.blank_error")
      render "conversations/show", status: :unprocessable_content
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def ensure_participant!
    return if @conversation.participants.exists?(id: current_user.id)

    head :forbidden
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
