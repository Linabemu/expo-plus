class AddRefToFollower < ActiveRecord::Migration[7.0]
  def change
    add_reference :followers, :friend, references: :users, index: true
  end
end
