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

ActiveRecord::Schema[7.0].define(version: 2023_11_28_190237) do
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
    t.string "last_sensed"
  end

  create_table "lockers", force: :cascade do |t|
    t.bigint "locker_station_id", null: false
    t.integer "number"
    t.integer "state", default: 0
    t.integer "alto"
    t.integer "ancho"
    t.integer "largo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "estado", default: "Disponible"
    t.string "sensorm", default: "Cerrado"
    t.integer "sensors", default: 0
    t.string "propietario", default: "G13"
    t.string "codigo_d", default: "000000"
    t.string "codigo_r", default: "000000"
    t.integer "already_informed", default: 0
    t.index ["locker_station_id"], name: "index_lockers_on_locker_station_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "accion"
    t.integer "casillero"
    t.datetime "fecha"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "ecommerce_id", null: false
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
    t.index ["ecommerce_id"], name: "index_orders_on_ecommerce_id"
    t.index ["locker_id"], name: "index_orders_on_locker_id"
  end

  add_foreign_key "lockers", "locker_stations"
  add_foreign_key "orders", "ecommerces"
  add_foreign_key "orders", "lockers"
end
