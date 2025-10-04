FactoryBot.define do
  factory :product do
    user
    title { "Sample Product" }
    description { "Simple description" }
    price { 999.99 }
    status { :draft }
    association :category
  end
end
