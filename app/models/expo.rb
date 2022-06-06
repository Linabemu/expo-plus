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

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :title, :tags, :price_type ],
    associated_against: {
      place: [ :address_name, :address_city, :address_zipcode ]
    },
    using: {
      tsearch: { prefix: true }
    }

  def average_rating
    reviews.average(:rating)
  end

  def self.tags
    pluck(:tags).flatten.uniq.sort
  end

end
