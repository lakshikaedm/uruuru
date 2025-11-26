module CategoriesHelper
  def category_label(category)
    return "" if category.blank?

    key = category.slug.presence || category.name.to_s.parameterize
    I18n.t("categories.#{key}", default: category.name)
  end
end
