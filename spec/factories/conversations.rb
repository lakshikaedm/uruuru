FactoryBot.define do
  factory :conversation do
    association :product
    association :buyer, factory: :user
    association :seller, factory: :user
  end
end
