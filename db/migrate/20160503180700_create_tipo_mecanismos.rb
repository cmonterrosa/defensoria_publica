class CreateTipoMecanismos < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `tipo_mecanismos`;"
    create_table :tipo_mecanismos do |t|
    	t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40   
      t.timestamps
    end
    execute "ALTER TABLE `tipo_mecanismos` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    TipoMecanismo.create(:clave => "medi", :descripcion => "MEDIACIÓN") unless TipoMecanismo.exists?(:clave => "medi")
    TipoMecanismo.create(:clave => "conc", :descripcion => "CONCILIACIÓN") unless TipoMecanismo.exists?(:clave => "conc")
    TipoMecanismo.create(:clave => "junt", :descripcion => "JUNTA RESTAURATIVA") unless TipoMecanismo.exists?(:clave => "junt")

  end

  def self.down
    drop_table :tipo_mecanismos
    execute "DROP TABLE IF EXISTS `tipo_mecanismos`;"
  end
end
