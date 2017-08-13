class CreateCheckins < ActiveRecord::Migration[5.0]
  def change
    create_table :checkins do |t|
      t.integer :user_id, null: false
      t.integer :hotel_id, null: false
      t.datetime :date_of_checkin, null: false

      t.timestamps

      t.index :user_id
      t.index :hotel_id
      t.index [:date_of_checkin, :user_id], unique: true
    end
  end
end
