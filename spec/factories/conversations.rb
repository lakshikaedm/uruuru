FactoryBot.define do
  factory :conversation do
    product
    buyer factory: %i[user]
    seller factory: %i[user]
  end
end
