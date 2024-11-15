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

ActiveRecord::Schema[7.0].define(version: 2024_11_08_234846) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "city", null: false
    t.string "state"
    t.string "postal_code", null: false
    t.string "country", default: "US"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["street", "postal_code"], name: "index_addresses_on_street_and_postal_code", unique: true
  end

  create_table "inspections", force: :cascade do |t|
    t.integer "score"
    t.date "occurred_on", null: false
    t.integer "category", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id", "occurred_on", "category"], name: "index_inspections_on_search_fields", unique: true
    t.index ["restaurant_id"], name: "index_inspections_on_restaurant_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_owners_on_address_id"
    t.index ["name", "address_id"], name: "index_owners_on_name_and_address_id", unique: true
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number", limit: 15
    t.bigint "address_id", null: false
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_restaurants_on_address_id"
    t.index ["name", "address_id"], name: "index_restaurants_on_name_and_address_id", unique: true
    t.index ["owner_id"], name: "index_restaurants_on_owner_id"
  end

  create_table "violation_types", force: :cascade do |t|
    t.integer "class_code", null: false
    t.integer "risk", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_code", "risk", "description"], name: "index_violation_types_on_unique_fields", unique: true
  end

  create_table "violations", force: :cascade do |t|
    t.bigint "violation_type_id", null: false
    t.bigint "inspection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspection_id"], name: "index_violations_on_inspection_id"
    t.index ["violation_type_id"], name: "index_violations_on_violation_type_id"
  end

  add_foreign_key "inspections", "restaurants"
  add_foreign_key "owners", "addresses"
  add_foreign_key "restaurants", "addresses"
  add_foreign_key "restaurants", "owners"
  add_foreign_key "violations", "inspections"
  add_foreign_key "violations", "violation_types"
end
