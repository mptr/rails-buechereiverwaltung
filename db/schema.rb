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

ActiveRecord::Schema.define(version: 2021_07_06_165551) do

  create_table "authors", force: :cascade do |t|
    t.string "family_name"
    t.string "given_name"
    t.text "affiliation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "book_id", null: false
    t.index ["author_id"], name: "index_authors_books_on_author_id"
    t.index ["book_id"], name: "index_authors_books_on_book_id"
  end

  create_table "book_instances", force: :cascade do |t|
    t.integer "book_id", null: false
    t.string "shelfmark"
    t.date "purchased_at"
    t.integer "lended_by_id"
    t.integer "reserved_by_id"
    t.datetime "checkout_at"
    t.date "due_at"
    t.datetime "returned_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_instances_on_book_id"
    t.index ["lended_by_id"], name: "index_book_instances_on_lended_by_id"
    t.index ["reserved_by_id"], name: "index_book_instances_on_reserved_by_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.integer "publisher_id", null: false
    t.integer "pub_year", default: 2021
    t.integer "edition", default: 1
    t.string "isbn", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "family_name"
    t.string "given_name"
    t.text "address"
    t.string "password"
    t.boolean "blocked", default: false
    t.text "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.boolean "admin", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "book_instances", "books"
  add_foreign_key "book_instances", "users", column: "lended_by_id"
  add_foreign_key "book_instances", "users", column: "reserved_by_id"
  add_foreign_key "books", "publishers"
end
