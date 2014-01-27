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

ActiveRecord::Schema.define(version: 20140127025209) do

  create_table "accounts", force: true do |t|
    t.string  "name",                                     null: false
    t.integer "plan_id",                                  null: false
    t.integer "balance"
    t.string  "investment_type"
    t.decimal "interest_rate",   precision: 10, scale: 0
    t.integer "term"
  end

  create_table "manipulator_templates", force: true do |t|
    t.string   "name",                                                      null: false
    t.integer  "user_id",                                                   null: false
    t.string   "formula",               limit: 4096,                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "javascript",            limit: 16777215
    t.string   "kind",                                   default: "factor", null: false
    t.string   "image_url"
    t.string   "can_formula",           limit: 4096
    t.string   "can_javascript",        limit: 40960
    t.boolean  "per_person",                             default: false
    t.string   "do_formula",            limit: 4096
    t.text     "do_javascript"
    t.integer  "priority",                               default: 5,        null: false
    t.text     "description"
    t.string   "description_more_link"
  end

  create_table "manipulators", force: true do |t|
    t.string   "name",                                 null: false
    t.date     "start"
    t.date     "end"
    t.integer  "manipulator_template_id",              null: false
    t.integer  "plan_id"
    t.string   "params",                  limit: 4096, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "when"
    t.integer  "plan_user_id"
    t.string   "start_type"
    t.integer  "start_plan_user_id"
  end

  create_table "plan_users", force: true do |t|
    t.integer "plan_id",                 null: false
    t.string  "relation_name"
    t.string  "name",                    null: false
    t.date    "born"
    t.integer "profession_id"
    t.string  "gender",        limit: 1, null: false
  end

  create_table "plans", force: true do |t|
    t.string   "name",                              null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      default: "California", null: false
  end

  create_table "professions", force: true do |t|
    t.string "name", null: false
  end

  create_table "tax_brackets", force: true do |t|
    t.integer "tax_rate_schedule_id",                         null: false
    t.integer "range_top",                                    null: false
    t.decimal "rate",                 precision: 5, scale: 2, null: false
  end

  create_table "tax_rate_schedules", force: true do |t|
    t.string "name", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variable_properties", force: true do |t|
    t.integer "manipulator_template_id",              null: false
    t.string  "name",                                 null: false
    t.string  "var_type",                             null: false
    t.string  "default",                 default: "", null: false
    t.string  "options"
    t.text    "description"
    t.string  "description_more_link"
    t.string  "depends_on"
  end

end
