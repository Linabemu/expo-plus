class AddRefToFollower < ActiveRecord::Migration[7.0]
  def change
    add_reference :followers, :friend, references: :users, null: false, index: true, foreign_key: { to_table: :users}
  end
end
