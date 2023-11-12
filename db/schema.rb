# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_12_050955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ecommerces", force: :cascade do |t|
    t.string "name", null: false
    t.string "key"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locker_stations", force: :cascade do |t|
    t.string "name"
    t.string "access_key"
    t.integer "state"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lockers", force: :cascade do |t|
    t.bigint "locker_stations_id", null: false
    t.integer "state", default: 0
    t.integer "height"
    t.integer "width"
    t.integer "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locker_stations_id"], name: "index_lockers_on_locker_stations_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "ecommerces_id", null: false
    t.integer "state", default: 0
    t.string "deposit_password"
    t.string "retrieve_password"
    t.string "operator_contact"
    t.string "client_contact"
    t.string "operator_name"
    t.string "client_name"
    t.datetime "delivery_time"
    t.datetime "retrieve_time"
    t.integer "height"
    t.integer "width"
    t.integer "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "locker_id", null: false
    t.index ["ecommerces_id"], name: "index_orders_on_ecommerces_id"
    t.index ["locker_id"], name: "index_orders_on_locker_id"
  end

  add_foreign_key "lockers", "locker_stations", column: "locker_stations_id"
  add_foreign_key "orders", "ecommerces", column: "ecommerces_id"
  add_foreign_key "orders", "lockers"
end
