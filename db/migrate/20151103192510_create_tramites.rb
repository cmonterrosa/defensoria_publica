class CreateTramites < ActiveRecord::Migration
  def self.up
    create_table :tramites do |t|
      t.column :nuc, :string, :limit => 18
      t.column :carpeta_investigacion, :string, :limit => 20
      t.column :fechahora_recepcion, :datetime
      t.column :fechahora_asistencia, :datetime
      t.column :fechahora_atencion, :datetime
      t.column :fiscalia, :string, :limit => 60
      t.column :causa_penal, :string
      t.column :calificacion_de_control_detencion, :string, :limit => 40
      t.column :calificacion_juridica, :string, :limit => 60
      t.column :asesor_juridico, :string, :limit => 80
      t.column :ministerio_publico, :string, :limit => 80
      t.column :defensor_id, :integer
      t.column :observaciones, :string
      t.timestamps
    end

    add_index :tramites, :nuc, :name => "tramites_nuc"
    add_index :tramites, :carpeta_investigacion, :name => "tramites_carpeta_investigacion"
    add_index :tramites, :defensor_id, :name => "tramites_defensor"
  end

  def self.down
    drop_table :tramites
  end
end
