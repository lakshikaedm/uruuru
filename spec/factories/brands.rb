FactoryBot.define do
  factory :brand do
    sequence(:name) { |n| "Brand #{n}" }
    slug { name.parameterize }
  end
end
