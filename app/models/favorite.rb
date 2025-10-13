class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :product, counter_cache: true

  validates :user_id, uniqueness: { scope: :product_id }
end
