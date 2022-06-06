class Proposal < ApplicationRecord
  belongs_to :user
  belongs_to :expo

  validates :date_proposale, presence: true
  validates :description, presence: true
end
