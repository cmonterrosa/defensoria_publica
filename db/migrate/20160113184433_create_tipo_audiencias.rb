class CreateTipoAudiencias < ActiveRecord::Migration
  def self.up
    create_table :tipo_audiencias do |t|
      t.column :descripcion, :string, :limit => 120
      t.column :etapa, :string, :limit => 60
    end

    TipoAudiencia.create(:descripcion=>"AUDIENCIA DE CONTROL DE DETENCIÓN", :etapa => "INICIAL") unless TipoAudiencia.find_by_descripcion("AUDIENCIA DE CONTROL DE DETENCIÓN")
    TipoAudiencia.create(:descripcion=>"AUDIENCIA DE ETAPA INTERMEDIA ORAL", :etapa => "INTERMEDIA") unless TipoAudiencia.find_by_descripcion("AUDIENCIA DE ETAPA INTERMEDIA ORAL")
    TipoAudiencia.create(:descripcion=>"AUDIENCIA DE JUICIO ORAL", :etapa => "JUICIO ORAL") unless TipoAudiencia.find_by_descripcion("AUDIENCIA DE JUICIO ORAL")
  end

  def self.down
    drop_table :tipo_audiencias
  end
end
