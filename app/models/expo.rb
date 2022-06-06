class Expo < ApplicationRecord
  belongs_to :place
  has_many :reviews, dependent: :destroy
  has_many :wishes, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :users, through: :reviews

  validates :title, presence: true
  validates :date_start, presence: true
  validates :date_end, presence: true

  has_one_attached :photo


  def average_rating
    reviews.average(:rating)
  end

  def self.tags
    pluck(:tags).flatten.uniq.sort
  end

end
