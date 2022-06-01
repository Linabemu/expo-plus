class Place < ApplicationRecord
  has_many :expos, dependent: :destroy

  validates :address_name, uniqueness: true
end
