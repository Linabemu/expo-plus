class Expo < ApplicationRecord
  belongs_to :place
  has_many :reviews
  has_many :wishes
  has_many :proposals
  has_many :users, through: :reviews
end
