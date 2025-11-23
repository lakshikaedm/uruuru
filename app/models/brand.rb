class Brand < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  scope :top_for_homepage, lambda {
    left_joins(:products)
      .group(:id)
      .order(Arel.sql("COUNT(products.id) DESC, brands.created_at DESC"))
      .limit(6)
  }

  private

  def set_slug
    self.slug = name.parameterize
  end
end
