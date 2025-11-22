require "rails_helper"

RSpec.describe "OrdersController#create (shipping)", type: :request do
  let(:user)        { create(:user) }
  let(:fake_order)  { build_stubbed(:order, id: 123, user: user) }
  let(:service_spy) { instance_double(Orders::CreateFromCart) }
  let(:tokyo_params) do
    {
      order: {
        shipping_name: "Taro",
        shipping_phone: "090-0000-0000",
        shipping_postal_code: "100-0001",
        shipping_prefecture: "Tokyo",
        shipping_city: "Chiyoda",
        shipping_address1: "1-1-1",
        shipping_address2: ""
      }
    }
  end

  before do
    sign_in user
    allow(DbCart).to receive(:new).and_return(instance_double(DbCart, empty?: false))
    allow(Orders::CreateFromCart).to receive(:new).and_return(service_spy)
    allow(service_spy).to receive(:call).and_return(fake_order)
  end

  it "calculates shipping-yen from prefecture and passes it to the service" do
    post orders_path, params: tokyo_params

    expect(Orders::CreateFromCart).to have_received(:new) do |args|
      expect(args[:shipping_params].to_h).to include(
        shipping_name: "Taro",
        shipping_prefecture: "Tokyo",
        shipping_yen: 500
      )
    end
    expect(response).to redirect_to(order_path(fake_order))
  end

  it "omits shipping yen when prefecture is blank" do
    blank_pref_params = tokyo_params.deep_dup
    blank_pref_params[:order][:shipping_prefecture] = ""

    post orders_path, params: blank_pref_params

    expect(Orders::CreateFromCart).to have_received(:new) do |args|
      expect(args[:shipping_params].to_h).not_to have_key(:shipping_yen)
    end
    expect(response).to have_http_status(:redirect)
  end
end
