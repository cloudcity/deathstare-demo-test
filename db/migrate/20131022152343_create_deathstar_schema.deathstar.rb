# This migration comes from deathstar (originally 20131021215630)
class CreateDeathstarSchema < ActiveRecord::Migration
  def change

    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"

    create_table "deathstar_client_devices", force: true do |t|
      t.integer "end_point_id"
      t.string "client_device_id"
      t.datetime "client_device_created_at"
      t.string "user_name"
      t.string "user_email"
      t.string "user_password"
      t.datetime "user_created_at"
      t.string "session_token"
      t.datetime "session_created_at"
      t.string "user_id"
    end

    add_index "deathstar_client_devices", ["client_device_id", "end_point_id"], name: "index_client_devices_on_client_device_id_and_end_point_id", unique: true, using: :btree
    add_index "deathstar_client_devices", ["end_point_id", "client_device_created_at"], name: "index_client_devices_device_creation", using: :btree
    add_index "deathstar_client_devices", ["end_point_id", "session_created_at"], name: "index_client_devices_on_end_point_id_and_session_created_at", using: :btree
    add_index "deathstar_client_devices", ["end_point_id", "user_created_at"], name: "index_client_devices_on_end_point_id_and_user_created_at", using: :btree
    add_index "deathstar_client_devices", ["end_point_id"], name: "index_client_devices_on_end_point_id", using: :btree
    add_index "deathstar_client_devices", ["user_email", "end_point_id"], name: "index_client_devices_on_user_email_and_end_point_id", unique: true, using: :btree
    add_index "deathstar_client_devices", ["user_name", "end_point_id"], name: "index_client_devices_on_user_name_and_end_point_id", unique: true, using: :btree

    create_table "deathstar_end_points", force: true do |t|
      t.string "base_url"
      t.string "label"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "deathstar_end_points", ["base_url"], name: "index_end_points_on_base_url", unique: true, using: :btree

    create_table "deathstar_test_results", force: true do |t|
      t.integer "test_session_id", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "suite_name"
      t.string "test_name"
      t.text "messages"
    end

    add_index "deathstar_test_results", ["test_session_id", "created_at"], name: "index_test_results_on_test_session_id_and_created_at", using: :btree
    add_index "deathstar_test_results", ["test_session_id"], name: "index_test_results_on_test_session_id", using: :btree

    create_table "deathstar_test_sessions", force: true do |t|
      t.string "base_url", null: false
      t.integer "devices", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text "comment"
      t.string "suite_names", default: [], null: false, array: true
      t.integer "end_point_id"
      t.integer "run_time"
    end
  end
end
