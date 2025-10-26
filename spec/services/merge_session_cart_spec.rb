require "rails_helper"

RSpec.describe MergeSessionCart do
  let!(:user)       { create(:user) }
  let!(:category)   { create(:category) }
  let!(:camera)     { create(:product, price: 1000, category: category) }
  let!(:lens)       { create(:product, price: 2000, category: category) }
  let(:session)     { {} }

  it "moves session items into user's DB and clears session" do
    SessionCart.new(session).add(camera.id, 2)
    SessionCart.new(session).add(lens.id, 1)

    described_class.new(session: session, user: user).call

    expect(user.cart).to be_present
    expect(user.cart.cart_items.pluck(:product_id, :quantity))
      .to contain_exactly([camera.id, 2], [lens.id, 1])
    expect(session[SessionCart::SESSION_KEY]).to eq({})
  end

  it "sums quantities when the user already has items" do
    user.create_cart!
    user.cart.add(camera.id, 1)

    SessionCart.new(session).add(camera.id, 3)

    described_class.new(session: session, user: user).call

    expect(user.cart.cart_items.find_by(product_id: camera.id).quantity).to eq(4)
  end
end
