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

ActiveRecord::Schema.define(version: 20141209052924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id"
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_id"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  add_index "activities", ["unit_id"], name: "index_activities_on_unit_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.integer  "unit_id"
    t.string   "data_file_name",          limit: 255, null: false
    t.string   "data_content_type",       limit: 255
    t.integer  "data_file_size"
    t.string   "type",                    limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_original_file_name"
    t.integer  "user_id"
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  add_index "ckeditor_assets", ["unit_id"], name: "index_ckeditor_assets_on_unit_id", using: :btree
  add_index "ckeditor_assets", ["updated_at"], name: "index_ckeditor_assets_on_updated_at", using: :btree
  add_index "ckeditor_assets", ["user_id"], name: "index_ckeditor_assets_on_user_id", using: :btree

  create_table "councils", force: true do |t|
    t.string   "name",           limit: 255
    t.integer  "council_number"
    t.string   "state",          limit: 255
    t.string   "city",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "councils", ["council_number"], name: "index_councils_on_council_number", using: :btree
  add_index "councils", ["name"], name: "index_councils_on_name", using: :btree
  add_index "councils", ["state"], name: "index_councils_on_state", using: :btree

  create_table "counselors", force: true do |t|
    t.integer  "merit_badge_id"
    t.integer  "user_id"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counselors", ["merit_badge_id", "user_id", "unit_id"], name: "index_counselors_on_merit_badge_id_and_user_id_and_unit_id", unique: true, using: :btree
  add_index "counselors", ["merit_badge_id"], name: "index_counselors_on_merit_badge_id", using: :btree
  add_index "counselors", ["unit_id"], name: "index_counselors_on_unit_id", using: :btree
  add_index "counselors", ["user_id"], name: "index_counselors_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "email_attachments", force: true do |t|
    t.integer  "email_message_id"
    t.string   "attachment",         limit: 255
    t.integer  "file_size"
    t.string   "content_type",       limit: 255
    t.string   "original_file_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_attachments", ["email_message_id"], name: "index_email_attachments_on_email_message_id", using: :btree

  create_table "email_messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "unit_id"
    t.text     "message"
    t.string   "subject",        limit: 255
    t.datetime "sent_at"
    t.string   "sub_unit_ids",   limit: 255, default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "send_to_option",             default: 1
    t.string   "id_token",       limit: 255
  end

  add_index "email_messages", ["id_token"], name: "index_email_messages_on_id_token", using: :btree
  add_index "email_messages", ["sent_at"], name: "index_email_messages_on_sent_at", using: :btree
  add_index "email_messages", ["unit_id"], name: "index_email_messages_on_unit_id", using: :btree
  add_index "email_messages", ["updated_at"], name: "index_email_messages_on_updated_at", using: :btree
  add_index "email_messages", ["user_id"], name: "index_email_messages_on_user_id", using: :btree

  create_table "email_messages_events", id: false, force: true do |t|
    t.integer "email_message_id"
    t.integer "event_id"
  end

  add_index "email_messages_events", ["email_message_id", "event_id"], name: "index_email_messages_events_on_email_message_id_and_event_id", using: :btree
  add_index "email_messages_events", ["event_id", "email_message_id"], name: "index_email_messages_events_on_event_id_and_email_message_id", using: :btree

  create_table "email_messages_users", id: false, force: true do |t|
    t.integer "email_message_id"
    t.integer "user_id"
  end

  add_index "email_messages_users", ["email_message_id", "user_id"], name: "index_email_messages_users_on_email_message_id_and_user_id", using: :btree
  add_index "email_messages_users", ["user_id", "email_message_id"], name: "index_email_messages_users_on_user_id_and_email_message_id", using: :btree

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
    t.integer  "need_carpool_seats", default: 0
    t.integer  "has_carpool_seats",  default: 0
  end

  add_index "event_signups", ["adults_attending"], name: "index_event_signups_on_adults_attending", using: :btree
  add_index "event_signups", ["event_id"], name: "index_event_signups_on_event_id", using: :btree
  add_index "event_signups", ["scout_id", "event_id"], name: "index_event_signups_on_scout_id_and_event_id", using: :btree
  add_index "event_signups", ["scouts_attending"], name: "index_event_signups_on_scouts_attending", using: :btree
  add_index "event_signups", ["siblings_attending"], name: "index_event_signups_on_siblings_attending", using: :btree

  create_table "events", force: true do |t|
    t.integer  "unit_id"
    t.string   "kind",                 limit: 255
    t.string   "name",                 limit: 255
    t.boolean  "send_reminders",                   default: true
    t.string   "notifier_type",        limit: 255
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "signup_required",                  default: false
    t.datetime "signup_deadline"
    t.string   "location_name",        limit: 255
    t.string   "location_address1",    limit: 255
    t.string   "location_address2",    limit: 255
    t.string   "location_city",        limit: 255
    t.string   "location_state",       limit: 255
    t.string   "location_zip_code",    limit: 255
    t.string   "location_map_url",     limit: 255
    t.string   "attire",               limit: 255
    t.text     "message"
    t.text     "fees"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.integer  "attendee_count",                   default: 0
    t.string   "signup_token",         limit: 255
    t.datetime "reminder_sent_at"
    t.string   "ical",                 limit: 255
    t.integer  "ical_file_size"
    t.string   "ical_content_type",    limit: 255
    t.datetime "ical_updated_at"
    t.integer  "ical_sequence",                    default: 0
    t.string   "ical_uuid",            limit: 255
    t.string   "sl_profile",           limit: 255
    t.string   "sl_uid",               limit: 255
    t.integer  "type_of_health_forms",             default: 0
  end

  add_index "events", ["end_at"], name: "index_events_on_end_at", using: :btree
  add_index "events", ["reminder_sent_at"], name: "index_events_on_reminder_sent_at", using: :btree
  add_index "events", ["send_reminders"], name: "index_events_on_send_reminders", using: :btree
  add_index "events", ["signup_deadline"], name: "index_events_on_signup_deadline", using: :btree
  add_index "events", ["signup_required"], name: "index_events_on_signup_required", using: :btree
  add_index "events", ["signup_token"], name: "index_events_on_signup_token", using: :btree
  add_index "events", ["start_at"], name: "index_events_on_start_at", using: :btree
  add_index "events", ["unit_id"], name: "index_events_on_unit_id", using: :btree
  add_index "events", ["updated_at"], name: "index_events_on_updated_at", using: :btree

  create_table "events_sub_units", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "sub_unit_id"
  end

  add_index "events_sub_units", ["event_id", "sub_unit_id"], name: "index_events_sub_units_on_event_id_and_sub_unit_id", using: :btree
  add_index "events_sub_units", ["sub_unit_id", "event_id"], name: "index_events_sub_units_on_sub_unit_id_and_event_id", using: :btree

  create_table "events_users", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "events_users", ["event_id", "user_id"], name: "index_events_users_on_event_id_and_user_id", using: :btree
  add_index "events_users", ["user_id", "event_id"], name: "index_events_users_on_user_id_and_event_id", using: :btree

  create_table "health_forms", force: true do |t|
    t.integer  "unit_id"
    t.integer  "user_id"
    t.date     "part_a_date"
    t.date     "part_b_date"
    t.date     "part_c_date"
    t.date     "florida_sea_base_date"
    t.date     "philmont_date"
    t.date     "northern_tier_date"
    t.date     "summit_tier_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "health_forms", ["unit_id"], name: "index_health_forms_on_unit_id", using: :btree
  add_index "health_forms", ["updated_at"], name: "index_health_forms_on_updated_at", using: :btree
  add_index "health_forms", ["user_id"], name: "index_health_forms_on_user_id", using: :btree

  create_table "merit_badges", force: true do |t|
    t.string   "name",                     limit: 255
    t.string   "year_created",             limit: 255
    t.boolean  "eagle_required",                       default: false
    t.boolean  "discontinued",                         default: false
    t.string   "bsa_advancement_id",       limit: 255
    t.string   "patch_image_url",          limit: 255
    t.string   "mb_org_url",               limit: 255
    t.string   "mb_org_worksheet_pdf_url", limit: 255
    t.string   "mb_org_worksheet_doc_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merit_badges", ["name"], name: "index_merit_badges_on_name", using: :btree
  add_index "merit_badges", ["updated_at"], name: "index_merit_badges_on_updated_at", using: :btree

  create_table "notifiers", force: true do |t|
    t.integer  "user_id"
    t.string   "kind",       limit: 255
    t.string   "account",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifiers", ["user_id"], name: "index_notifiers_on_user_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.integer  "unit_id"
    t.integer  "user_id"
    t.boolean  "public",         default: false
    t.text     "update_history"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "front_page",     default: false
    t.datetime "deactivated_at"
  end

  add_index "pages", ["deactivated_at"], name: "index_pages_on_deactivated_at", using: :btree
  add_index "pages", ["position"], name: "index_pages_on_position", using: :btree
  add_index "pages", ["public"], name: "index_pages_on_public", using: :btree
  add_index "pages", ["unit_id"], name: "index_pages_on_unit_id", using: :btree
  add_index "pages", ["updated_at"], name: "index_pages_on_updated_at", using: :btree
  add_index "pages", ["user_id"], name: "index_pages_on_user_id", using: :btree

  create_table "phones", force: true do |t|
    t.integer  "user_id"
    t.string   "number",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind",                   default: 0
  end

  add_index "phones", ["user_id"], name: "index_phones_on_user_id", using: :btree

  create_table "sms_messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "unit_id"
    t.text     "message"
    t.datetime "sent_at"
    t.string   "sub_unit_ids",   limit: 255
    t.integer  "send_to_option",             default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sms_messages", ["unit_id"], name: "index_sms_messages_on_unit_id", using: :btree
  add_index "sms_messages", ["user_id"], name: "index_sms_messages_on_user_id", using: :btree

  create_table "sms_messages_users", id: false, force: true do |t|
    t.integer "sms_message_id"
    t.integer "user_id"
  end

  add_index "sms_messages_users", ["sms_message_id", "user_id"], name: "index_sms_messages_users_on_sms_message_id_and_user_id", using: :btree
  add_index "sms_messages_users", ["user_id", "sms_message_id"], name: "index_sms_messages_users_on_user_id_and_sms_message_id", using: :btree

  create_table "sub_units", force: true do |t|
    t.integer  "unit_id"
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_units", ["unit_id"], name: "index_sub_units_on_unit_id", using: :btree
  add_index "sub_units", ["updated_at"], name: "index_sub_units_on_updated_at", using: :btree

  create_table "unit_positions", force: true do |t|
    t.integer  "user_id"
    t.integer  "unit_id"
    t.string   "leadership"
    t.string   "additional"
    t.integer  "role",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unit_positions", ["user_id", "unit_id"], name: "index_unit_positions_on_user_id_and_unit_id", using: :btree

  create_table "units", force: true do |t|
    t.string   "unit_type",   limit: 255
    t.string   "unit_number", limit: 255
    t.string   "city",        limit: 255
    t.string   "state",       limit: 255
    t.string   "time_zone",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sl_uid",      limit: 255
    t.integer  "council_id"
  end

  add_index "units", ["council_id"], name: "index_units_on_council_id", using: :btree

  create_table "units_users", id: false, force: true do |t|
    t.integer "unit_id"
    t.integer "user_id"
  end

  add_index "units_users", ["unit_id", "user_id"], name: "index_units_users_on_unit_id_and_user_id", unique: true, using: :btree
  add_index "units_users", ["user_id", "unit_id"], name: "index_units_users_on_user_id_and_unit_id", unique: true, using: :btree

  create_table "user_relationships", id: false, force: true do |t|
    t.integer "adult_id"
    t.integer "scout_id"
  end

  add_index "user_relationships", ["adult_id", "scout_id"], name: "index_user_relationships_on_adult_id_and_scout_id", using: :btree
  add_index "user_relationships", ["scout_id", "adult_id"], name: "index_user_relationships_on_scout_id_and_adult_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                           limit: 255, default: ""
    t.string   "encrypted_password",              limit: 255, default: ""
    t.string   "reset_password_token",            limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                               default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",              limit: 255
    t.string   "last_sign_in_ip",                 limit: 255
    t.string   "confirmation_token",              limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",               limit: 255
    t.integer  "failed_attempts",                             default: 0
    t.string   "unlock_token",                    limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                      limit: 255
    t.string   "last_name",                       limit: 255
    t.string   "address1",                        limit: 255
    t.string   "address2",                        limit: 255
    t.string   "city",                            limit: 255
    t.string   "state",                           limit: 255
    t.string   "zip_code",                        limit: 255
    t.date     "birth"
    t.string   "leadership_role",                 limit: 255
    t.string   "time_zone",                       limit: 255
    t.string   "type",                            limit: 255
    t.integer  "sub_unit_id"
    t.string   "rank",                            limit: 255
    t.boolean  "send_reminders",                              default: true
    t.datetime "deactivated_at"
    t.string   "leadership_position",             limit: 255
    t.string   "additional_leadership_positions", limit: 255
    t.string   "signup_token",                    limit: 255
    t.string   "sms_number",                      limit: 255
    t.datetime "sms_number_verified_at"
    t.boolean  "blast_email",                                 default: true
    t.boolean  "blast_sms"
    t.boolean  "event_reminder_email",                        default: true
    t.boolean  "event_reminder_sms"
    t.boolean  "signup_deadline_email",                       default: true
    t.boolean  "signup_deadline_sms"
    t.string   "picture",                         limit: 255
    t.integer  "picture_file_size"
    t.string   "picture_content_type",            limit: 255
    t.string   "picture_original_file_name",      limit: 255
    t.datetime "picture_updated_at"
    t.datetime "sms_verification_sent_at"
    t.string   "sl_profile",                      limit: 255
    t.string   "sl_uid",                          limit: 255
    t.string   "alternate_email",                 limit: 255
    t.string   "sms_provider",                    limit: 255
    t.boolean  "sms_message",                                 default: true
    t.boolean  "weekly_newsletter_email",                     default: true
    t.boolean  "monthly_newsletter_email",                    default: true
    t.integer  "role",                                        default: 10
  end

  add_index "users", ["additional_leadership_positions"], name: "index_users_on_additional_leadership_positions", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deactivated_at"], name: "index_users_on_deactivated_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["encrypted_password"], name: "index_users_on_encrypted_password", using: :btree
  add_index "users", ["leadership_position"], name: "index_users_on_leadership_position", using: :btree
  add_index "users", ["rank"], name: "index_users_on_rank", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["send_reminders"], name: "index_users_on_send_reminders", using: :btree
  add_index "users", ["signup_token"], name: "index_users_on_signup_token", using: :btree
  add_index "users", ["sub_unit_id"], name: "index_users_on_sub_unit_id", using: :btree
  add_index "users", ["type"], name: "index_users_on_type", using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["updated_at"], name: "index_users_on_updated_at", using: :btree

end
