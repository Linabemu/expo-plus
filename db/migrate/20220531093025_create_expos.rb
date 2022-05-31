class CreateExpos < ActiveRecord::Migration[7.0]
  def change
    create_table :expos do |t|
      t.integer :api_records_id
      t.date :api_updated_at
      t.string :title
      t.text :lead_text
      t.text :description
      t.string :tags, array: true
      t.string :cover_url
      t.string :cover_alt
      t.string :cover_credit
      t.date :date_start
      t.date :date_end
      t.string :occurences, array: true
      t.string :date_description
      t.string :price_type
      t.string :price_detail
      t.string :contact_url

      t.timestamps
    end
  end
end
