%w[Clothing Caps Bags Mugs Electronics].each do |name|
  Category.find_or_create_by!(name: name)
end
