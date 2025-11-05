class ShippingCalculator
  def call(prefecture:)
    case prefecture.to_s.downcase
    when "hokkaido"
      1000
    when "okinawa"
      1200
    when "tokyo"
      500
    else
      700
    end
  end
end
