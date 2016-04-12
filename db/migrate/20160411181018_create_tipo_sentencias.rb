class CreateTipoSentencias < ActiveRecord::Migration
  def self.up
    create_table :tipo_sentencias do |t|
    	t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    TipoSentencia.create(:clave => "cond", :descripcion => "CONDENATORIA") unless TipoSentencia.exists?(:clave => "cond")
    TipoSentencia.create(:clave => "abs", :descripcion => "ABSOLUTORIA") unless TipoSentencia.exists?(:clave => "abs")
  end

  def self.down
    drop_table :tipo_sentencias
  end
end
