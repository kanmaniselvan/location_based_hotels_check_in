class CreateHotels < ActiveRecord::Migration[5.0]
  def change
    create_table :hotels do |t|
      t.string :place_id, null: false
      t.string :name, null: false
      t.text :vicinity, null: false
      t.json :hotel_attributes, null: false, default: '{}'

      t.timestamps

      t.index [:name, :place_id], unique: true
      t.index :place_id, unique: true
      t.index :vicinity
    end
  end
end
