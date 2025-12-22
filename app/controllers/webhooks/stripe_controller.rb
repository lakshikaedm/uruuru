module Webhooks
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload   = request.body.read
      signature = request.env["HTTP_STRIPE_SIGNATURE"]

      event = Stripe::Webhook.construct_event(
        payload,
        signature,
        ENV.fetch("STRIPE_WEBHOOK_SECRET", nil)
      )

      handle_event(event)

      head :ok
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      head :bad_request
    end

    private

    def handle_event(event)
      case event.type
      when "checkout.session.completed"
        session  = event.data.object
        order_id = session.metadata&.order_id || session.client_reference_id

        return if order_id.blank?

        order = Order.find_by(id: order_id)
        return unless order

        return if order.paid?

        Orders::MarkPaid.new(order: order).call
        OrderMailer.with(locale: I18n.locale).confirmation(order).deliver_later
      end
    end
  end
end
