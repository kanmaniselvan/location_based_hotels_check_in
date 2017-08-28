# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170714010843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checkins", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "hotel_id",        null: false
    t.datetime "date_of_checkin", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["date_of_checkin", "user_id"], name: "index_checkins_on_date_of_checkin_and_user_id", unique: true, using: :btree
    t.index ["hotel_id"], name: "index_checkins_on_hotel_id", using: :btree
    t.index ["user_id"], name: "index_checkins_on_user_id", using: :btree
  end

  create_table "hotels", force: :cascade do |t|
    t.string   "place_id",                        null: false
    t.string   "name",                            null: false
    t.text     "vicinity",                        null: false
    t.json     "hotel_attributes", default: "{}", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["name", "place_id"], name: "index_hotels_on_name_and_place_id", unique: true, using: :btree
    t.index ["place_id"], name: "index_hotels_on_place_id", unique: true, using: :btree
    t.index ["vicinity"], name: "index_hotels_on_vicinity", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
