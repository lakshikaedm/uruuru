require "rails_helper"

RSpec.describe "Stripe webhook", type: :request do
  it "calls Orders::MarkPaid on checkout.session.complete" do
    order     = create(:order, status: :pending)
    mark_paid = instance_spy(Orders::MarkPaid, call: true)

    event = Stripe::Event.construct_from(
      type: "checkout.session.completed",
      data: {
        object: {
          metadata: { order_id: order.id.to_s }
        }
      }
    )

    allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
    allow(Orders::MarkPaid).to receive(:new).and_return(mark_paid)

    post "/webhooks/stripe", params: "{}", headers: { "HTTP_STRIPE_SIGNATURE" => "signature" }

    expect(mark_paid).to have_received(:call)
    expect(response).to have_http_status(:ok)
  end
end
