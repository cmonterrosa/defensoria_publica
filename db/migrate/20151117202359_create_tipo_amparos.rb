class CreateTipoAmparos < ActiveRecord::Migration
  def self.up
    create_table :tipo_amparos do |t|
      t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
    end

    TipoAmparo.create(:clave => "dire", :descripcion => "DIRECTO") unless TipoAmparo.exists?(:clave => "dire")
    TipoAmparo.create(:clave => "idir", :descripcion => "INDIRECTO") unless TipoAmparo.exists?(:clave => "idir")
  end

  def self.down
    drop_table :tipo_amparos
  end
end
