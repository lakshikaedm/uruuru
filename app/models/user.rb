class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  enum :role, { user: 0, admin: 1 }

  has_many :products, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_one_attached :avatar
  has_many :orders, dependent: :nullify
  has_one :cart, dependent: :destroy
  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :messages, dependent: :destroy

  validates :username, presence: true, length: { maximum: 30 }

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    user.email = auth.info.email.presence || "facebook-#{auth.uid}@example.com"
    user.username = auth.info.name.presence || "fb-user-#{auth.uid}"
    user.password ||= Devise.friendly_token[0, 20]

    user.save!
    user
  end
end
