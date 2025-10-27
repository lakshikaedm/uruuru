FactoryBot.define do
  factory :order do
    user { nil }
    subtotal_yen { 1 }
    shipping_yen { 1 }
    total_yen { 1 }
    status { "MyString" }
    shipping_name { "MyString" }
    shipping_phone { "MyString" }
    shipping_postal_code { "MyString" }
    shipping_prefecture { "MyString" }
    shipping_city { "MyString" }
    shipping_address1 { "MyString" }
    shipping_address2 { "MyString" }
  end
end
