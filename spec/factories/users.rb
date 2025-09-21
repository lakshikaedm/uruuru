FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 5..8) }
    email { Faker::Internet.unique.email }
    password { "password123" }
  end
end
