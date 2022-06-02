class Expo < ApplicationRecord
  belongs_to :place
  has_many :reviews, dependent: :destroy
  has_many :wishes
  has_many :proposals
  has_many :users, through: :reviews

  validates :title, presence: true
  validates :date_start, presence: true
  validates :date_end, presence: true

  has_one_attached :photo
end
