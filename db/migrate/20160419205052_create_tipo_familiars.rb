class CreateTipoFamiliars < ActiveRecord::Migration
  def self.up
    create_table :tipo_familiars do |t|
    	t.column :clave, :string, :limit => 5
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    TipoFamiliar.create(:clave => "esp", :descripcion => "ESPOSO/A") unless TipoFamiliar.exists?(:clave => "esp")
    TipoFamiliar.create(:clave => "herma", :descripcion => "HERMANO/A") unless TipoFamiliar.exists?(:clave => "herma")
    TipoFamiliar.create(:clave => "padre", :descripcion => "PADRE") unless TipoFamiliar.exists?(:clave => "padre")
    TipoFamiliar.create(:clave => "madre", :descripcion => "MADRE") unless TipoFamiliar.exists?(:clave => "madre")

  end

  def self.down
    drop_table :tipo_familiars
  end
end
