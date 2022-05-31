class AddPlaceRefToExpos < ActiveRecord::Migration[7.0]
  def change
    add_reference :expos, :place, null: false, foreign_key: true
  end
end
