class Following < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: "User"
  validates :user, uniqueness: { scope: :receiver }
end
