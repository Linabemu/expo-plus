class Message < ApplicationRecord
  belongs_to :user
  belongs_to :proposal

  validates :content, presence: true
end
