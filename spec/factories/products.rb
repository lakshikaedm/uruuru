FactoryBot.define do
  factory :product do
    user
    sequence(:title) { |n| "Product #{n}" }
    description { "Simple description" }
    price { 999.99 }
    status { :draft }
    category
  end
end
