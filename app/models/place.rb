class Place < ApplicationRecord
  has_many :expos, dependent: :destroy
end
