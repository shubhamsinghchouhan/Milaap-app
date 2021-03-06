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

ActiveRecord::Schema.define(version: 2021_11_28_131020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_details", force: :cascade do |t|
    t.string "account_number"
    t.string "ifsc_number"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bank_details_on_user_id"
  end

  create_table "loan_applications", force: :cascade do |t|
    t.decimal "inflow_amount", precision: 12, scale: 2, default: "0.0"
    t.decimal "outflow_amount", precision: 12, scale: 2, default: "0.0"
    t.integer "creditibility_score", default: 0
    t.boolean "is_approved", default: false
    t.bigint "bank_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_detail_id"], name: "index_loan_applications_on_bank_detail_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "pan_card", limit: 10
    t.string "aadhar_number", limit: 12
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bank_details", "users"
  add_foreign_key "loan_applications", "bank_details"
end
