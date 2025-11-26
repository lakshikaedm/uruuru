module BrandsHelper
  def brand_label(brand)
    return "" if brand.blank?

    key = brand.slug.presence || brand.name.to_s.parameterize
    I18n.t("brands.#{key}", default: brand.name)
  end
end
