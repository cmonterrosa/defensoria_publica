class CreateAudiencias < ActiveRecord::Migration
  def self.up
    create_table :audiencias do |t|
      t.integer :cve_aud
      t.datetime :fechahora_atencion
      t.date :fecha
      t.integer :turno, :defensor_id, :estado_audiencia_id, :tipo_juicio_id
      t.string :asunto, :limit => 500
      t.string :observaciones, :limit => 300
      t.string :procedencia, :limit => 140
      t.string :persona_id, :limit => 36
      t.integer :adscripcion_id
      t.boolean :activo
      t.boolean :atendido
      t.integer :user_id
      t.boolean :es_inicio
      t.timestamps
    end
    add_index :audiencias, :cve_aud, :name => "audiencias_cve_aud"
    add_index :audiencias, :defensor_id, :name => "audiencias_defensor"
    add_index :audiencias, :persona_id, :name => "audiencias_persona"
    add_index :audiencias, :turno, :name => "audiencias_turno"
    add_index :audiencias, :user_id, :name => "audiencias_usuario"
    add_index :audiencias, [:adscripcion_id, :fecha], :name => "audiencias_adscripcion_fecha"
    add_index :audiencias, [:defensor_id, :fecha, :atendido, :activo], :name => "audiencias_monitor"
  end

  def self.down
    drop_table :audiencias
  end
end
