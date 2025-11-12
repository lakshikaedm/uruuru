class Message < ApplicationRecord
  MAX_BODY_LENGTH = 500

  belongs_to :conversation
  belongs_to :user

  validates :body, presence: true, length: { maximum: MAX_BODY_LENGTH }
end
