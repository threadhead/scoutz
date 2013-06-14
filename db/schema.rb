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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130614173803) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_id"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  add_index "activities", ["unit_id"], name: "index_activities_on_unit_id"

  create_table "ckeditor_assets", force: true do |t|
    t.integer  "unit_id"
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "email_attachments", force: true do |t|
    t.integer  "email_message_id"
    t.string   "attachment"
    t.integer  "file_size"
    t.string   "content_type"
    t.string   "original_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_attachments", ["email_message_id"], name: "index_email_attachments_on_email_message_id"

  create_table "email_messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "unit_id"
    t.text     "message"
    t.string   "subject"
    t.datetime "sent_at"
    t.string   "sub_unit_ids",   default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "send_to_option", default: 1
    t.string   "id_token"
  end

  add_index "email_messages", ["id_token"], name: "index_email_messages_on_id_token"
  add_index "email_messages", ["sent_at"], name: "index_email_messages_on_sent_at"
  add_index "email_messages", ["unit_id"], name: "index_email_messages_on_unit_id"
  add_index "email_messages", ["user_id"], name: "index_email_messages_on_user_id"

  create_table "email_messages_events", id: false, force: true do |t|
    t.integer "email_message_id"
    t.integer "event_id"
  end

  add_index "email_messages_events", ["email_message_id", "event_id"], name: "index_email_messages_events_on_email_message_id_and_event_id"
  add_index "email_messages_events", ["event_id", "email_message_id"], name: "index_email_messages_events_on_event_id_and_email_message_id"

  create_table "email_messages_users", id: false, force: true do |t|
    t.integer "email_message_id"
    t.integer "user_id"
  end

  add_index "email_messages_users", ["email_message_id", "user_id"], name: "index_email_messages_users_on_email_message_id_and_user_id"
  add_index "email_messages_users", ["user_id", "email_message_id"], name: "index_email_messages_users_on_user_id_and_email_message_id"

  create_table "event_signups", force: true do |t|
    t.integer  "event_id"
    t.integer  "scout_id"
    t.integer  "scouts_attending",   default: 0
    t.integer  "adults_attending",   default: 0
    t.integer  "siblings_attending", default: 0
    t.text     "comment"
    t.datetime "canceled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_signups", ["adults_attending"], name: "index_event_signups_on_adults_attending"
  add_index "event_signups", ["event_id"], name: "index_event_signups_on_event_id"
  add_index "event_signups", ["scout_id", "event_id"], name: "index_event_signups_on_scout_id_and_event_id"
  add_index "event_signups", ["scouts_attending"], name: "index_event_signups_on_scouts_attending"
  add_index "event_signups", ["siblings_attending"], name: "index_event_signups_on_siblings_attending"

  create_table "events", force: true do |t|
    t.integer  "unit_id"
    t.string   "kind"
    t.string   "name"
    t.boolean  "send_reminders",    default: true
    t.string   "notifier_type"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "signup_required",   default: false
    t.datetime "signup_deadline"
    t.string   "location_name"
    t.string   "location_address1"
    t.string   "location_address2"
    t.string   "location_city"
    t.string   "location_state"
    t.string   "location_zip_code"
    t.string   "location_map_url"
    t.string   "attire"
    t.text     "message"
    t.text     "fees"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.integer  "attendee_count",    default: 0
    t.string   "signup_token"
    t.datetime "reminder_sent_at"
  end

  add_index "events", ["end_at"], name: "index_events_on_end_at"
  add_index "events", ["reminder_sent_at"], name: "index_events_on_reminder_sent_at"
  add_index "events", ["send_reminders"], name: "index_events_on_send_reminders"
  add_index "events", ["signup_deadline"], name: "index_events_on_signup_deadline"
  add_index "events", ["signup_required"], name: "index_events_on_signup_required"
  add_index "events", ["signup_token"], name: "index_events_on_signup_token"
  add_index "events", ["start_at"], name: "index_events_on_start_at"
  add_index "events", ["unit_id"], name: "index_events_on_unit_id"

  create_table "events_sub_units", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "sub_unit_id"
  end

  add_index "events_sub_units", ["event_id", "sub_unit_id"], name: "index_events_sub_units_on_event_id_and_sub_unit_id"
  add_index "events_sub_units", ["sub_unit_id", "event_id"], name: "index_events_sub_units_on_sub_unit_id_and_event_id"

  create_table "events_users", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "events_users", ["event_id", "user_id"], name: "index_events_users_on_event_id_and_user_id"
  add_index "events_users", ["user_id", "event_id"], name: "index_events_users_on_user_id_and_event_id"

  create_table "notifiers", force: true do |t|
    t.integer  "user_id"
    t.string   "kind"
    t.string   "account"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifiers", ["user_id"], name: "index_notifiers_on_user_id"

  create_table "phones", force: true do |t|
    t.integer  "user_id"
    t.string   "kind"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["user_id"], name: "index_phones_on_user_id"

  create_table "sub_units", force: true do |t|
    t.integer  "unit_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_units", ["unit_id"], name: "index_sub_units_on_unit_id"

  create_table "units", force: true do |t|
    t.string   "unit_type"
    t.string   "unit_number"
    t.string   "city"
    t.string   "state"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units_users", id: false, force: true do |t|
    t.integer "unit_id"
    t.integer "user_id"
  end

  add_index "units_users", ["unit_id", "user_id"], name: "index_units_users_on_unit_id_and_user_id"
  add_index "units_users", ["user_id", "unit_id"], name: "index_units_users_on_user_id_and_unit_id"

  create_table "user_relationships", id: false, force: true do |t|
    t.integer "adult_id"
    t.integer "scout_id"
  end

  add_index "user_relationships", ["adult_id", "scout_id"], name: "index_user_relationships_on_adult_id_and_scout_id"
  add_index "user_relationships", ["scout_id", "adult_id"], name: "index_user_relationships_on_scout_id_and_adult_id"

  create_table "users", force: true do |t|
    t.string   "email",                           default: ""
    t.string   "encrypted_password",              default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                 default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.date     "birth"
    t.string   "leadership_role"
    t.string   "role"
    t.string   "time_zone"
    t.string   "type"
    t.integer  "sub_unit_id"
    t.string   "rank"
    t.boolean  "send_reminders",                  default: true
    t.datetime "deactivated_at"
    t.string   "leadership_position"
    t.string   "additional_leadership_positions"
    t.string   "signup_token"
    t.string   "picture"
    t.integer  "picture_file_size"
    t.string   "picture_content_type"
    t.string   "picture_original_file_name"
    t.datetime "picture_updated_at"
  end

  add_index "users", ["additional_leadership_positions"], name: "index_users_on_additional_leadership_positions"
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["deactivated_at"], name: "index_users_on_deactivated_at"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["encrypted_password"], name: "index_users_on_encrypted_password"
  add_index "users", ["leadership_position"], name: "index_users_on_leadership_position"
  add_index "users", ["rank"], name: "index_users_on_rank"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["role"], name: "index_users_on_role"
  add_index "users", ["send_reminders"], name: "index_users_on_send_reminders"
  add_index "users", ["signup_token"], name: "index_users_on_signup_token"
  add_index "users", ["sub_unit_id"], name: "index_users_on_sub_unit_id"
  add_index "users", ["type"], name: "index_users_on_type"
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
