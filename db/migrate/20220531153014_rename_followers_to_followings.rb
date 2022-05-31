class RenameFollowersToFollowings < ActiveRecord::Migration[7.0]
  def change
    rename_table :followers, :followings
  end
end
