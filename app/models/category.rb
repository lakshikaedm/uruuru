class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  private
  def set_slug
    self.slug = name.parameterize
  end
end
