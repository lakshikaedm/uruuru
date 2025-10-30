class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { user: 0, admin: 1 }

  has_many :products, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_one_attached :avatar
  has_many :orders, dependent: :nullify
  has_one :cart, dependent: :destroy

  validates :username, presence: true, length: { maximum: 30 }
end
