class CreateFollowings < ActiveRecord::Migration[7.0]

  # https://stackoverflow.com/questions/34208348/model-design-users-have-friends-which-are-users
  # Check link above to understand this table which act as a self join of user
  # this link is also useful : https://kubilaycaglayan.medium.com/how-to-create-the-simplest-friendship-model-on-rails-de0ab51448ec

  def change
    create_table :followers, id: false do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps

    end

  end
end
