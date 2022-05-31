class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :address_name
      t.string :address_street
      t.string :address_city
      t.string :address_zipcode
      t.float :lat
      t.float :lon
      t.string :access_link

      t.timestamps
    end
  end
end
