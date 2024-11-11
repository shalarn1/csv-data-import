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

ActiveRecord::Schema[7.0].define(version: 2024_11_08_214626) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "violation_types", force: :cascade do |t|
    t.integer "classification_code", null: false
    t.integer "risk_category", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_code", "risk_category", "description"], name: "index_violation_types_on_unique_fields", unique: true
  end

end
