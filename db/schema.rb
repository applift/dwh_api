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

ActiveRecord::Schema.define(version: 2019_08_08_080216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "database_credentials", force: :cascade do |t|
    t.string "user", null: false
    t.string "password", null: false
    t.string "database", null: false
    t.string "host", null: false
    t.string "port", null: false
    t.string "salt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "endpoints", force: :cascade do |t|
    t.text "query", null: false
    t.bigint "token_id", null: false
    t.bigint "database_credential_id", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["database_credential_id"], name: "index_endpoints_on_database_credential_id"
    t.index ["token_id"], name: "index_endpoints_on_token_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_tokens_on_code"
  end

end
