class CreateTipoSentencias < ActiveRecord::Migration
  def self.up
   execute "DROP TABLE IF EXISTS `tipo_sentencias`;"
   create_table :tipo_sentencias  do |t|
      t.string :clave, :limit => 4
      t.string :descripcion, :limit => 40
      t.timestamps
    end
    execute "ALTER TABLE `tipo_sentencias` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    #TipoSentencia.reset_column_information
    TipoSentencia.create(:clave => "cond", :descripcion => "CONDENATORIA") unless TipoSentencia.exists?(:clave => "cond")
    TipoSentencia.create(:clave => "abso", :descripcion => "ABSOLUTORIA") unless TipoSentencia.exists?(:clave => "abso")
  end

  def self.down
    drop_table :tipo_sentencias
    execute "DROP TABLE IF EXISTS `tipo_sentencias`;"
  end
end
