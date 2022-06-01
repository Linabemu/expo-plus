class Proposal < ApplicationRecord
  belongs_to :user
  belongs_to :expo

  validates :date, presence: true
  validates :description, presence: true
end
