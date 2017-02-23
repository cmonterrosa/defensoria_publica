class CreateTramites < ActiveRecord::Migration
  def self.up
    create_table :tramites do |t|
      t.column :anio, :string, :limit => 4
      t.column :folio_expediente, :string, :limit => 5
      t.column :nuc, :string, :limit => 18
      t.column :registro_atencion, :string, :limit => 40
      t.column :carpeta_investigacion, :string, :limit => 40
      t.column :causa_penal, :string, :limit => 60
      t.column :fechahora_atencion, :datetime
      t.column :fiscalia_id, :integer
      t.column :calificacion_juridica, :string, :limit => 60
      t.column :defensor_id, :integer
      t.column :materia_id, :integer
      t.column :delito_norma_id, :integer
      t.column :observaciones, :string
      t.column :hecho_delictivo, :string, :limit => 140
      t.column :es_delito_grave, :boolean
      t.column :concluido, :boolean
      t.column :es_urgente, :boolean
      # Campos familiar/civil
      t.column :tipo_juicio_id, :integer
      t.column :solo_orientacion, :boolean
      t.column :organo_id, :integer
      t.column :num_expediente, :string, :limit => 20
      t.timestamps
    end

    add_index :tramites, :anio, :name => "tramites_anio"
    add_index :tramites, :nuc, :name => "tramites_nuc"
    add_index :tramites, :carpeta_investigacion, :name => "tramites_carpeta_investigacion"
    add_index :tramites, :causa_penal, :name => "tramites_causa_penal"
    add_index :tramites, [:defensor_id, :fechahora_atencion], :name => "tramites_defensor_fechahora_atencion"
    add_index :tramites, :defensor_id, :name => "tramites_defensor"
    add_index :tramites, :materia_id, :name => "tramites_materia"
    add_index :tramites, :concluido, :name => "tramites_concluido"
  end

  def self.down
    drop_table :tramites
  end
end
