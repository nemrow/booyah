# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131023160616) do

  create_table "addresses", :force => true do |t|
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "user_id"
    t.string   "lob_address_id"
    t.boolean  "default"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "keyword"
    t.string   "name"
  end

  create_table "credits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "to_id"
    t.integer  "user_id"
    t.string   "lob_order_id"
    t.string   "pdf_source"
    t.string   "jpg_source"
    t.float    "lob_cost"
    t.float    "user_cost"
    t.string   "lob_object_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "payment_source"
    t.integer  "address_id"
  end

  create_table "paypal_payments", :force => true do |t|
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "order_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "paypal_preapprovals", :force => true do |t|
    t.string   "key"
    t.integer  "user_id"
    t.boolean  "active",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "pictures", :force => true do |t|
    t.string   "pdf_source"
    t.string   "jpg_source"
    t.string   "lob_object_id"
    t.integer  "order_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "cell"
    t.string   "password_digest"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "role",                  :default => "user"
    t.string   "return_lob_address_id"
  end

end
