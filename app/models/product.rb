class Product < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  enum :status, { draft: 0, publish: 1, sold: 2 }

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
