class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :followings
  has_many :messages
  has_many :proposals, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :wishes, dependent: :destroy
  has_many :reviews

  validates :email, uniqueness: true
  has_one_attached :photo
end
