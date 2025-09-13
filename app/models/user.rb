class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # (no :confirmable)
  enum role: { user: 0, admin: 1 }

  has_many :products, dependent: :destroy

  validates :username, presence: true, length: { maximum: 30 }
end
