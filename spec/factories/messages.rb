FactoryBot.define do
  factory :message do
    association :conversation
    association :user
    body { "Hello" }
  end
end
