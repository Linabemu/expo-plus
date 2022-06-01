class Expo < ApplicationRecord
  belongs_to :place
  has_many :reviews
  has_many :wishes
  has_many :proposals
  has_many :users, through: :reviews

  validates :title, presence: true
  validates :date_start, presence: true
  validates :date_end, presence: true
end
