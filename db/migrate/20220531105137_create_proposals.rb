class CreateProposals < ActiveRecord::Migration[7.0]
  def change
    create_table :proposals do |t|
      t.boolean :confirmed
      t.string :occurences, array: true
      t.integer :max_participants
      t.references :user, null: false, foreign_key: true
      t.references :expo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
