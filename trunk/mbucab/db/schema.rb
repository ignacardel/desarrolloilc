# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110609194500) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "name"
    t.string   "number"
    t.string   "zone"
    t.string   "city"
    t.string   "country"
    t.integer  "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "nickname"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "account"
    t.string   "firstname"
    t.string   "middlename"
    t.string   "lastname"
    t.string   "surname"
    t.date     "birthday"
    t.integer  "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "rif"
    t.string   "phone"
    t.string   "fax"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creditcards", :force => true do |t|
    t.integer  "number"
    t.date     "expdate"
    t.integer  "code"
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "account"
    t.string   "password"
    t.string   "name"
    t.string   "lastname"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.datetime "date"
    t.string   "recipient"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "status"
    t.datetime "collectiondate"
    t.datetime "deliverydate"
    t.integer  "address_id"
    t.integer  "client_id"
    t.integer  "creditcard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "route_id"
    t.string   "street"
    t.string   "name"
    t.integer  "number"
    t.string   "zone"
    t.string   "city"
    t.string   "country"
    t.integer  "zip"
    t.integer  "order_type"
    t.float    "extra"
    t.integer  "company_id"
    t.integer  "external"
  end

  create_table "packages", :force => true do |t|
    t.string   "description"
    t.float    "weight"
    t.float    "price"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", :force => true do |t|
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
