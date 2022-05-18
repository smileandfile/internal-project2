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

ActiveRecord::Schema.define(version: 20181024171958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "intarray"
  enable_extension "ltree"
  enable_extension "pg_buffercache"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "postgres_fdw"
  enable_extension "uuid-ossp"

  create_table "account_entries", force: :cascade do |t|
    t.bigint "account_id"
    t.string "description"
    t.decimal "amount_deducted", precision: 20, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_entries_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "domain_id"
    t.string "description"
    t.integer "gstin_allowed_left"
    t.decimal "per_gstin_amount", precision: 20, scale: 10
    t.decimal "credits", precision: 20, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_accounts_on_domain_id"
  end

  create_table "asps", force: :cascade do |t|
    t.string "party_name"
    t.string "mobile_number"
    t.string "email"
    t.string "address"
    t.string "username"
    t.string "secret_password"
    t.integer "gstin_request_count"
    t.integer "token_request_count"
    t.integer "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_token_creation_times", force: :cascade do |t|
  end

  create_table "branches", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gstin_id"
    t.integer "entity_id"
    t.index ["entity_id"], name: "index_branches_on_entity_id"
    t.index ["gstin_id"], name: "index_branches_on_gstin_id"
  end

  create_table "branches_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "branch_id", null: false
  end

  create_table "common_api_auths", force: :cascade do |t|
    t.string "client_id"
    t.string "client_secret"
    t.string "username"
    t.string "password"
    t.string "endpoint_name"
    t.string "gsp_environment"
    t.string "auth_token"
    t.datetime "auth_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_app_key"
  end

  create_table "common_api_logs", force: :cascade do |t|
    t.datetime "requested_at"
    t.string "gstin"
    t.json "request_headers"
    t.string "api_name"
    t.datetime "response_at"
    t.string "response_type"
    t.string "invalid_reason"
    t.json "response_headers"
    t.string "username"
    t.string "base_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "mobile_number"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "domains", id: :serial, force: :cascade do |t|
    t.citext "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "address"
    t.string "firm_turnover"
    t.boolean "is_active", default: false
    t.integer "package_id"
    t.datetime "package_start_date"
    t.datetime "package_end_date"
    t.integer "working_level"
    t.index ["name"], name: "index_domains_on_name", unique: true
    t.index ["package_id"], name: "index_domains_on_package_id"
    t.index ["user_id"], name: "index_domains_on_user_id"
  end

  create_table "entities", id: :serial, force: :cascade do |t|
    t.string "company_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "domain_id"
    t.text "address"
    t.string "pan_number"
    t.index ["domain_id"], name: "index_entities_on_domain_id"
  end

  create_table "entities_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "entity_id", null: false
  end

  create_table "eway_api_logs", force: :cascade do |t|
    t.datetime "requested_at"
    t.string "gstin"
    t.json "request_headers"
    t.string "api_name"
    t.datetime "response_at"
    t.string "response_type"
    t.string "invalid_reason"
    t.json "response_headers"
    t.string "base_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "eway_bill_user_id"
    t.index ["eway_bill_user_id"], name: "index_eway_api_logs_on_eway_bill_user_id"
  end

  create_table "eway_bill_multiple_auths", force: :cascade do |t|
    t.bigint "ewaybill_id"
    t.string "gstin"
    t.string "auth_token"
    t.datetime "auth_token_expires_at"
    t.string "auth_encrypted_sek"
    t.string "auth_decrypted_sek"
    t.string "app_key", limit: 1000000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "token_created_at"
    t.index ["ewaybill_id"], name: "index_eway_bill_multiple_auths_on_ewaybill_id"
  end

  create_table "ewaybills", force: :cascade do |t|
    t.string "party_name"
    t.string "mobile_number"
    t.string "email"
    t.string "address"
    t.string "gstin"
    t.string "client_id"
    t.string "client_secret"
    t.integer "bill_request_count"
    t.integer "token_request_count"
    t.integer "is_active"
    t.string "auth_token"
    t.datetime "auth_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_encrypted_sek"
    t.string "auth_decrypted_sek"
    t.string "app_key", limit: 1000000
    t.string "endpoint_name"
    t.integer "eway_environment"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "email"
    t.string "mobile_number"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "file_download_gstins", force: :cascade do |t|
    t.string "gstin_number"
    t.string "state_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.string "auth_encrypted_sek"
    t.string "auth_decrypted_sek"
    t.string "username"
    t.bigint "user_id"
    t.bigint "entity_id"
    t.integer "gsp_environment"
    t.datetime "registration_date"
    t.integer "dealer_type"
    t.bigint "turnover_last_year"
    t.bigint "turnover_current"
    t.integer "domain_id"
    t.string "endpoint_name"
    t.datetime "auth_expires_at"
    t.string "app_key", limit: 1000000
    t.datetime "auth_token_expires_at"
    t.datetime "server_time"
    t.integer "actual_time_of_token_expires"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_file_download_gstins_on_branch_id"
    t.index ["entity_id"], name: "index_file_download_gstins_on_entity_id"
    t.index ["user_id"], name: "index_file_download_gstins_on_user_id"
  end

  create_table "file_downloads", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "gstin_id"
    t.integer "est"
    t.string "ek"
    t.string "token"
    t.integer "file_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_ip"
    t.string "return_period"
    t.json "log"
    t.datetime "file_eta"
    t.string "waiting_message"
    t.bigint "file_download_gstin_id"
    t.json "gst_response"
    t.index ["file_download_gstin_id"], name: "index_file_downloads_on_file_download_gstin_id"
    t.index ["gstin_id"], name: "index_file_downloads_on_gstin_id"
    t.index ["user_id"], name: "index_file_downloads_on_user_id"
  end

  create_table "gst_access_items", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "domain"
    t.datetime "requested_at"
    t.string "gstin"
    t.string "return_period"
    t.json "request_headers"
    t.string "api_name"
    t.integer "request_payload_size"
    t.string "transaction_id"
    t.string "ip_address"
    t.datetime "response_at"
    t.string "response_type"
    t.string "invalid_reason"
    t.json "response_headers"
    t.string "reference_id"
    t.string "user_email"
    t.integer "response_payload_size"
    t.string "base_url"
    t.integer "user_id"
  end

  create_table "gstins", id: :serial, force: :cascade do |t|
    t.string "gstin_number"
    t.string "state_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.string "auth_encrypted_sek"
    t.string "auth_decrypted_sek"
    t.string "username"
    t.integer "user_id"
    t.integer "entity_id"
    t.integer "gsp_environment"
    t.datetime "auth_expires_at"
    t.string "app_key", limit: 1000000
    t.datetime "registration_date"
    t.integer "dealer_type"
    t.bigint "turnover_last_year"
    t.bigint "turnover_current"
    t.integer "domain_id"
    t.string "endpoint_name"
    t.datetime "auth_token_expires_at"
    t.datetime "server_time"
    t.integer "actual_time_of_token_expires"
    t.index ["domain_id"], name: "index_gstins_on_domain_id"
    t.index ["entity_id"], name: "index_gstins_on_entity_id"
    t.index ["user_id"], name: "index_gstins_on_user_id"
  end

  create_table "gstins_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "gstin_id", null: false
  end

  create_table "gstr3bs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gstr_version_managers", force: :cascade do |t|
    t.string "gstr1", default: "v1.1"
    t.string "gstr2", default: "v0.3"
    t.string "gstr1a", default: "v0.3"
    t.string "gstr2a", default: "v0.3"
    t.string "gstr3", default: "v0.3"
    t.string "gstr3b", default: "v0.3"
    t.string "gstr4", default: "v0.3"
    t.string "gstr6", default: "v0.3"
    t.string "ledger", default: "v0.3"
    t.string "public_api", default: "v1.0"
    t.string "public_api_authentication", default: "v1.0"
    t.string "gst_authentication", default: "v0.2"
    t.string "dsc", default: "v0.2"
    t.string "gstr_common_api", default: "v0.3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "individual_files", id: :serial, force: :cascade do |t|
    t.string "decrypted_file"
    t.integer "state"
    t.integer "file_download_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_file"
    t.integer "invoice_count"
    t.string "hash_value"
    t.string "filename"
    t.index ["file_download_id"], name: "index_individual_files_on_file_download_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.decimal "amount", null: false
    t.string "currency", null: false
    t.string "tracking_id"
    t.string "billing_name"
    t.text "billing_address"
    t.string "billing_zip"
    t.string "billing_city"
    t.string "billing_state"
    t.string "billing_country"
    t.string "billing_tel"
    t.string "billing_email"
    t.string "delivery_name"
    t.string "delivery_address"
    t.string "delivery_city"
    t.string "delivery_state"
    t.string "delivery_country"
    t.string "delivery_tel"
    t.string "promo_code"
    t.string "discounted_amount"
    t.integer "status"
    t.string "cc_avenue_order_status"
    t.string "bank_ref_no"
    t.string "failure_message"
    t.string "payment_mode"
    t.string "card_name"
    t.string "status_code"
    t.string "status_message"
    t.string "merchant_param1"
    t.string "merchant_param2"
    t.string "merchant_param3"
    t.string "merchant_param4"
    t.string "merchant_param5"
    t.string "vault"
    t.string "offer_type"
    t.string "offer_code"
    t.string "discount_value"
    t.string "mer_amount"
    t.string "eci_value"
    t.string "retry"
    t.string "response_code"
    t.string "billing_notes"
    t.string "trans_date"
    t.string "bin_country"
    t.integer "package_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_payment_mode"
    t.integer "subscription"
    t.decimal "sgst", precision: 8, scale: 2
    t.decimal "cgst", precision: 8, scale: 2
    t.decimal "igst", precision: 8, scale: 2
    t.decimal "without_tax_amount", precision: 8, scale: 2
    t.integer "sub_package_id"
    t.integer "duration_months"
    t.datetime "offline_payment_date"
    t.boolean "payment_mode_lock", default: false
    t.string "invoice_number"
    t.string "token"
    t.boolean "is_payment_url_sent", default: false
    t.string "utr_number"
    t.string "bank_name"
    t.datetime "date_remittance"
    t.string "cheque_number"
    t.boolean "special_type", default: false
    t.string "gstin_number"
    t.string "pan_number"
    t.index ["package_id"], name: "index_orders_on_package_id"
    t.index ["sub_package_id"], name: "index_orders_on_sub_package_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "packages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "package_type"
    t.integer "cost"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expiry_duration_months"
    t.string "turnover_from"
    t.string "turnover_to"
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "parent_id"
    t.string "allowed_actions", default: [], array: true
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  create_table "snf_settings", id: :serial, force: :cascade do |t|
    t.text "whats_new"
    t.text "faqs"
    t.string "gstin_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_packages", id: :serial, force: :cascade do |t|
    t.bigint "turnover_from"
    t.bigint "turnover_to"
    t.bigint "annual"
    t.bigint "half_yearly"
    t.bigint "quarterly"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "package_id"
    t.index ["package_id"], name: "index_sub_packages_on_package_id"
  end

  create_table "uploads", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file_url"
    t.integer "file_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.integer "role"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "branch_id"
    t.integer "domain_id"
    t.string "phone_number"
    t.datetime "phone_verified_at"
    t.string "otp_secret_key"
    t.integer "email_otp"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["domain_id"], name: "index_users_on_domain_id"
    t.index ["email", "domain_id"], name: "index_users_on_email_and_domain_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "file_downloads", "users"
  add_foreign_key "gstins", "users"
  add_foreign_key "individual_files", "file_downloads"
end
