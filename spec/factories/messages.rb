FactoryBot.define do
  factory :message do
    conversation
    user
    body { "Hello" }
  end
end
