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

ActiveRecord::Schema.define(:version => 20121229161415) do

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",      :limit => 1024
    t.string   "url",        :limit => 1024
    t.string   "source"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "author",     :limit => 1024
  end

  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

  create_table "identifiers", :force => true do |t|
    t.integer "article_id"
    t.string  "body",       :limit => 2048
  end

  add_index "identifiers", ["article_id"], :name => "index_identifiers_on_article_id"

  create_table "imports", :force => true do |t|
    t.integer "user_id"
    t.string  "state"
  end

  create_table "users", :force => true do |t|
    t.integer  "zotero_uid"
    t.string   "zotero_username"
    t.string   "zotero_key"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "mendeley_uid"
    t.string   "mendeley_token"
    t.string   "mendeley_secret"
    t.string   "mendeley_username"
    t.string   "email",                :default => "", :null => false
    t.string   "encrypted_password",   :default => "", :null => false
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

end
