class CreateTipoSentencias < ActiveRecord::Migration
  def self.up
   execute "DROP TABLE IF EXISTS `tipo_sentencias`;"
   create_table :tipo_sentencias  do |t|
      t.string :clave, :limit => 4
      t.string :descripcion, :limit => 40
      t.boolean :tipo_penal
    end
    
    execute "ALTER TABLE `tipo_sentencias` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    #TipoSentencia.reset_column_information
    # TipoPenal
    TipoSentencia.create(:tipo_penal => true, :clave => "cond", :descripcion => "CONDENATORIA") unless TipoSentencia.exists?(:clave => "cond")
    TipoSentencia.create(:tipo_penal => true, :clave => "abso", :descripcion => "ABSOLUTORIA") unless TipoSentencia.exists?(:clave => "abso")
    
    # Demas Materias
    TipoSentencia.create(:tipo_penal => false, :clave => "inte", :descripcion => "INTERLOCUTORIA") unless TipoSentencia.exists?(:clave => "inte")
    TipoSentencia.create(:tipo_penal => false, :clave => "defi", :descripcion => "DEFINITIVA") unless TipoSentencia.exists?(:clave => "defi")
    TipoSentencia.create(:tipo_penal => false, :clave => "segu", :descripcion => "SEGUNDA INSTANCIA") unless TipoSentencia.exists?(:clave => "segu")


  end

  def self.down
    drop_table :tipo_sentencias
    execute "DROP TABLE IF EXISTS `tipo_sentencias`;"
  end
end
