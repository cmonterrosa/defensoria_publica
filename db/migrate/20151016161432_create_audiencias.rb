class CreateAudiencias < ActiveRecord::Migration
  def self.up
    create_table :audiencias do |t|
      t.datetime :fechahora_atencion
      t.date :fecha
      t.integer :turno, :defensor_id, :estado_audiencia_id
      t.string :asunto, :limit => 500
      t.string :observaciones, :limit => 300
      t.string :procedencia, :limit => 140
      t.string :persona_id, :limit => 36
      t.boolean :activo
      t.timestamps
    end
    add_index :audiencias, :defensor_id, :name => "audiencias_defensor"
    add_index :audiencias, :persona_id, :name => "audiencias_persona"
    add_index :audiencias, :turno, :name => "audiencias_turno"
     add_index :audiencias, :fecha, :name => "audiencias_fecha"
  end

  def self.down
    drop_table :audiencias
  end
end
