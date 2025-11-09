require "rails_helper"
RSpec.describe ShippingCalculator do
  subject(:calc) { described_class.new }

  it "returns 1000 for Hokkaido (case-sensitive)" do
    expect(calc.call(prefecture: "Hokkaido")).to eq 1000
    expect(calc.call(prefecture: "hokkaido")).to eq 1000
  end

  it "returns 1200 for Okinawa" do
    expect(calc.call(prefecture: "Okinawa")).to eq 1200
  end

  it "returns 500 for Tokyo" do
    expect(calc.call(prefecture: "Tokyo")).to eq 500
  end

  it "returns 700 for any other prefecture" do
    expect(calc.call(prefecture: "Shizuoka")).to eq 700
    expect(calc.call(prefecture: nil)).to eq 700
  end
end
