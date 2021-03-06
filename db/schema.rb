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

ActiveRecord::Schema.define(version: 2018_07_27_214645) do

  create_table "audiences", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "message_id"
    t.integer "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["id"], name: "index_classifications_on_id"
  end

  create_table "damages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "message_id"
    t.integer "impacted_service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
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

  create_table "impacted_services", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["id"], name: "index_impacted_services_on_id"
  end

  create_table "message_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "message_id"
    t.datetime "start"
    t.datetime "finish"
    t.integer "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "recipient_count"
    t.integer "viewed_count", default: 0
    t.integer "publisher_id"
    t.index ["message_id"], name: "index_message_logs_on_message_id"
    t.index ["publisher_id"], name: "index_message_logs_on_publisher_id"
  end

  create_table "messages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "subject"
    t.text "impact_statement"
    t.datetime "window_start"
    t.datetime "window_end"
    t.text "purpose"
    t.text "resolution"
    t.text "workaround"
    t.text "other_services"
    t.string "sender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "classification_id"
    t.integer "modifier_id"
    t.boolean "closed", default: false
    t.index ["id"], name: "index_messages_on_id"
  end

  create_table "modifiers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "open_ended"
    t.index ["id"], name: "index_modifiers_on_id"
  end

  create_table "publishers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "class_name"
    t.boolean "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipients", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.index ["id"], name: "index_recipients_on_id"
    t.index ["uid"], name: "index_recipients_on_uid"
  end

  create_table "settings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "item_name"
    t.text "item_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["id"], name: "index_settings_on_id"
  end

end
