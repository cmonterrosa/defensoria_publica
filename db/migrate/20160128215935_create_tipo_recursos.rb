class CreateTipoRecursos < ActiveRecord::Migration
  def self.up
    create_table :tipo_recursos do |t|
      t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    TipoRecurso.create(:clave => "apel", :descripcion => "APELACIÓN") unless TipoRecurso.exists?(:clave => "apel")
    TipoRecurso.create(:clave => "quej", :descripcion => "QUEJA") unless TipoRecurso.exists?(:clave => "quej")
    TipoRecurso.create(:clave => "revo", :descripcion => "REVOCACIÓN") unless TipoRecurso.exists?(:clave => "revo")
    TipoRecurso.create(:clave => "repo", :descripcion => "REPOSICIÓN") unless TipoRecurso.exists?(:clave => "repo")
    TipoRecurso.create(:clave => "cona", :descripcion => "CONTESTACIÓN DE AGRAVIOS") unless TipoRecurso.exists?(:clave => "cona")
    TipoRecurso.create(:clave => "expa", :descripcion => "EXPOSICIÓN DE AGRAVIOS") unless TipoRecurso.exists?(:clave => "expa")
    
  end

  def self.down
    drop_table :tipo_recursos
  end
end
