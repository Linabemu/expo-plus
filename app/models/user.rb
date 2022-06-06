class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :followings, dependent: :destroy
  has_many :subscriptions, class_name: "Following", foreign_key: :receiver_id, dependent: :destroy


  has_many :messages, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :wishes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :email, uniqueness: true
  has_one_attached :photo

  # Renvoie les proposals auxquelles je participe
  has_many :participations, through: :participants, source: :proposal


end
