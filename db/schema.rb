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

ActiveRecord::Schema.define(:version => 20151009175438) do

  create_table "adscripcions", :force => true do |t|
    t.string   "descripcion",  :limit => 20
    t.integer  "municipio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "municipios", :force => true do |t|
    t.string "descripcion", :limit => 60
  end

  create_table "personas", :force => true do |t|
    t.string   "enlace"
    t.string   "paterno"
    t.string   "materno"
    t.string   "nombre"
    t.string   "curp"
    t.string   "rfc"
    t.string   "telefono_celular"
    t.string   "telefono_casa"
    t.string   "telefono_trabajo"
    t.string   "email"
    t.string   "direccion_casa"
    t.string   "direccion_trabajo"
    t.date     "fecha_nacimiento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "telefono_alternativo", :limit => 20
  end

end
