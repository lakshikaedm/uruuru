require "net/http"
require "json"

class PostalCodesController < ApplicationController
  def show
    postal_code = params[:postal_code].to_s.gsub(/\D/, "")

    if postal_code.blank?
      render json: {
        error: "missing_postal_code",
        message: I18n.t("postal_codes.errors.missing_postal_code")
      }, status: :bad_request
      return
    end

    result = lookup_postal_code(postal_code)

    if result
      render json: result
    else
      render json: {
        error: "not_found",
        message: I18n.t("postal_codes.errors.not_found")
      }, status: :not_found
    end
  rescue JSON::ParserError, SocketError, Timeout::Error => e
    Rails.logger.error("Postal lookup failed: #{e.class}: #{e.message}")

    render json: {
      error: "service_unavailable",
      message: I18n.t("postal_codes.errors.service_unavailable")
    }, status: :service_unavailable
  end

  private

  def lookup_postal_code(postal_code)
    uri = URI("https://zipcloud.ibsnet.co.jp/api/search?zipcode=#{postal_code}")
    response = Net::HTTP.get_response(uri)
    return unless response.is_a?(Net::HTTPSuccess)

    body = JSON.parse(response.body)
    return if body["results"].blank?

    r = body["results"].first

    prefecture_ja = r["address1"]
    prefecture_en = JapanPrefectures.to_en(prefecture_ja)
    city          = "#{r['address2']}#{r['address3']}"

    {
      postal_code: postal_code,
      prefecture_ja: prefecture_ja,
      prefecture_en: prefecture_en,
      city: city
    }
  end
end
