class Proposal < ApplicationRecord
  belongs_to :user
  belongs_to :expo

  validates :date_proposale, presence: true
  validates :description, presence: true

  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :messages
end
