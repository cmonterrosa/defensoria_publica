class CreateTipoRecursos < ActiveRecord::Migration
  def self.up
    create_table :tipo_recursos do |t|
    	t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    TipoRecurso.create(:clave => "apel", :descripcion => "APELACIÓN") unless TipoAmparo.exists?(:clave => "apel")
    TipoRecurso.create(:clave => "rev", :descripcion => "REVOCACIÓN") unless TipoAmparo.exists?(:clave => "rev")
    
  end

  def self.down
    drop_table :tipo_recursos
  end
end
