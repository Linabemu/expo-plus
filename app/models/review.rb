class Review < ApplicationRecord
  belongs_to :user
  belongs_to :expo

  validates :rating, presence: true
  validates :comment, presence: true, length: { maximum: 500 }
end
