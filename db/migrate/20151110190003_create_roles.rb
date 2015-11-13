class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.column :name, :string, :limit => 24
      t.column :descripcion, :string, :limit => 80
      t.column :prioridad, :integer
   end

    ## Roles principales ##
    Role.create(:name => "admin", :descripcion => "ADMINISTRADOR DEL SISTEMA", :prioridad => 1)
    Role.create(:name => "directivo", :descripcion => "DIRECTIVO", :prioridad => 1)
    Role.create(:name => "jefedefensor", :descripcion => "JEFE DE DEFENSORES PUBLICOS", :prioridad => 1)
    Role.create(:name => "defensor", :descripcion => "DEFENSOR PUBLICO", :prioridad => 1)
    Role.create(:name => "solicitante", :descripcion => "SOLICITANTE", :prioridad => 1)
    
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