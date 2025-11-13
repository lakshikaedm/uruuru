class Conversation < ApplicationRecord
  belongs_to :product
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"

  has_many :messages, dependent: :destroy
  has_many :conversation_participants, dependent: :destroy
  has_many :participants, through: :conversation_participants, source: :user

  validates :product_id, uniqueness: { scope: %i[buyer_id seller_id] }

  scope :for_user, ->(user) { where("buyer_id = :id OR seller_id = :id", id: user.id) }
end
