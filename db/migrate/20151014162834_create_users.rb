class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :persona_id, :limit => 36
      t.string   :login,                     :limit => 40
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.datetime :last_login
      t.string :last_ip, :limit => "15"
      t.integer :adscripcion_id
      t.boolean :activo
      # Conexion a litigantes
      t.string :nombre_usuario_litigantes, :limit => 40
      t.string :password_litigantes, :limit => 32

    end
    add_index :users, :persona_id, :name => "user_persona", :unique => true
    add_index :users, [:persona_id, :activo],  :name => "user_persona_activo"
    add_index :users, [:adscripcion_id],  :name => "user_adscripcion"
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
