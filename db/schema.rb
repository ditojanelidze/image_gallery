# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_08_192759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "image", null: false
    t.string "uuid", limit: 50, null: false
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
    t.integer "height", null: false
    t.integer "width", null: false
    t.datetime "created_at", null: false
    t.index ["category_id"], name: "index_pictures_on_category_id"
    t.index ["user_id"], name: "index_pictures_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "username", limit: 50, null: false
    t.string "password", limit: 200, null: false
    t.datetime "created_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
