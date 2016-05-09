class CreateTipoMecanismos < ActiveRecord::Migration
  def self.up
    create_table :tipo_mecanismos do |t|
    	t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40   
      t.timestamps
    end

    TipoMecanismo.create(:clave => "medi", :descripcion => "MEDIACIÓN") unless TipoMecanismo.exists?(:clave => "medi")
    TipoMecanismo.create(:clave => "conc", :descripcion => "CONCILIACIÓN") unless TipoMecanismo.exists?(:clave => "conc")
    TipoMecanismo.create(:clave => "junt", :descripcion => "JUNTA RESTAURATIVA") unless TipoMecanismo.exists?(:clave => "junt")

  end

  def self.down
    drop_table :tipo_mecanismos
  end
end
