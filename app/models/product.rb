class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :brand, optional: true
  has_many_attached :images
  enum :status, { draft: 0, publish: 1, sold: 2 }

  scope :search, ->(q) { where("title ILIKE :q OR description ILIKE :q", q: "%#{q}%") if q.present? }
  scope :by_category, ->(id) { where(category_id: id) if id.present? }
  scope :by_brand, ->(id) { where(brand_id: id) if id.present? }
  scope :by_status, ->(s) { where(status: s) if s.present? }

  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
