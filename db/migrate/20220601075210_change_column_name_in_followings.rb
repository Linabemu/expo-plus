class ChangeColumnNameInFollowings < ActiveRecord::Migration[7.0]
  def change
    rename_column :followings, :friend_id, :receiver_id
  end
end
