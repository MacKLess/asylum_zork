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

ActiveRecord::Schema.define(version: 20171102210518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventory_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "room_id"
    t.boolean "in_inventory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "note_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room_name"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "x_coordinate"
    t.integer "y_coordinate"
    t.boolean "active"
    t.string "solution_item"
    t.boolean "north_exit"
    t.boolean "east_exit"
    t.boolean "south_exit"
    t.boolean "west_exit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visited"
    t.text "first_impression"
    t.integer "user_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "user_rooms", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.integer "item_id"
    t.integer "note_id"
    t.boolean "active"
    t.boolean "visited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "moves"
    t.text "game_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
