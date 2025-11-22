class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user  = order.user

    I18n.with_locale(params[:locale] || I18n.default_locale) do
      mail(
        to: @user.email,
        subject: I18n.t(
          "order_mailer.confirmation.subject",
          order_id: @order.id
        )
      )
    end
  end
end
