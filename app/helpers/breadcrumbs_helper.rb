module BreadcrumbsHelper
  def breadcrumb_items_for(product)
    items = [{ label: "Home", url: root_path, current: false }]

    if (cat = product.category)
      cat.path.each do |c|
        items << { label: c.name, url: category_path(c), current: false }
      end
    end

    items << { label: product.title, url: nil, current: true }
    items
  end

  def breadcrumb_items_for_category(category)
    items = [{ label: "Home", url: root_path, current: false }]

    if category
      category.path.each do |c|
        items << { label: c.name, url: category_path(c), current: false }
      end
      items.last[:current] = true
      items.last[:url] = nil
    end

    items
  end

  def breadcrumb_items_for_brand(brand)
    items = [{ label: "Home", url: root_path, current: false }]

    if brand
      items << {
        label: brand.name,
        url: brand_path(brand),
        current: true
      }
    end

    items
  end
end
