class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.column :name, :string, :limit => 24
      t.column :descripcion, :string, :limit => 80
      t.column :prioridad, :integer
   end

    ## Roles principales ##
    Role.create(:name => "admin", :descripcion => "ADMINISTRADOR DEL SISTEMA", :prioridad => 1)
    Role.create(:name => "directivo", :descripcion => "DIRECTIVO", :prioridad => 2)
    Role.create(:name => "jefedefensor", :descripcion => "JEFE DE DEFENSORES PUBLICOS", :prioridad => 3)
    Role.create(:name => "jefedefensorpenal", :descripcion => "JEFE DE DEFENSORES PENALES", :prioridad => 4)
    Role.create(:name => "defensorpenal", :descripcion => "DEFENSOR PUBLICO PENAL", :prioridad => 4)
    Role.create(:name => "defensor", :descripcion => "DEFENSOR PUBLICO", :prioridad => 6)
    Role.create(:name => "defensorapoyo", :descripcion => "DEFENSOR PUBLICO DE APOYO", :prioridad => 7)
    Role.create(:name => "notificante", :descripcion => "RECIBE NOTIFICACIONES DE TRAMITES", :prioridad => 8)
    Role.create(:name => "solicitante", :descripcion => "SOLICITANTE", :prioridad => 9)
    Role.create(:name => "recepcion", :descripcion => "RECEPCION EN MODULO", :prioridad => 10)
    
    # generate the join table
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"
  end

  def self.down
    drop_table "roles"
    drop_table "roles_users"
  end
end