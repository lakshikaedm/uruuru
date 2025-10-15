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
end
