class CreateTipoSentencias < ActiveRecord::Migration
  def self.up
   create_table :tipo_sentencias  do |t|
    	t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    TipoSentencia.create(:id => 1, :clave => "cond", :descripcion => "CONDENATORIA") unless TipoSentencia.exists?(:clave => "cond")
    TipoSentencia.create(:id => 2, :clave => "abs", :descripcion => "ABSOLUTORIA") unless TipoSentencia.exists?(:clave => "abs")
  end

  def self.down
    drop_table :tipo_sentencias
  end
end
