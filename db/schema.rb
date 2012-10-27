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

ActiveRecord::Schema.define(:version => 20120915042335) do

  create_table "apis", :force => true do |t|
    t.string   "key"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "member_id"
  end

  create_table "commenteds", :force => true do |t|
    t.integer  "commented_by_id"
    t.integer  "auther_id"
    t.integer  "topic_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "member_id"
    t.text     "body"
    t.integer  "topic_id"
    t.integer  "message_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "deleted",    :default => false
  end

  create_table "feeds", :force => true do |t|
    t.integer  "member_id"
    t.string   "action"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "member_id"
    t.integer  "inviter_id"
    t.string   "invite_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "email"
    t.string   "username",               :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true
  add_index "members", ["username"], :name => "index_members_on_username", :unique => true

  create_table "members_resources", :id => false, :force => true do |t|
    t.integer "member_id"
    t.integer "resource_id"
  end

  create_table "mentioneds", :force => true do |t|
    t.integer  "mention_by_id"
    t.integer  "mentioner_id"
    t.integer  "topic_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "praises", :force => true do |t|
    t.integer  "praise_by_id"
    t.integer  "praiser_id"
    t.integer  "model_id"
    t.string   "model_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "sense",      :default => 0
    t.integer  "member_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "resources", :force => true do |t|
    t.string   "md5"
    t.string   "filename"
    t.string   "subfix"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "resources_topics", :id => false, :force => true do |t|
    t.integer "resource_id"
    t.integer "topic_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.integer  "member_id"
    t.string   "title"
    t.text     "body"
    t.integer  "message_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "deleted",    :default => false
    t.integer  "viewpoint",  :default => 100
    t.datetime "sort_at",    :default => '2012-01-01 00:00:00'
  end

  create_table "videos", :force => true do |t|
    t.string   "link"
    t.integer  "topic_id"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
