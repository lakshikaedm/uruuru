class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: { user: 0, admin: 1 }

  has_many :products, dependent: :nullify

  validates :username, presence: true, length: { maximum: 30 }
end
