class CreateParticipantes < ActiveRecord::Migration
  def self.up
    create_table :participantes do |t|
      t.string :persona_id, :limit => 36
      t.integer :tipo_participante_id
      t.integer :entorno_id
      t.integer :marginacion_id
      t.integer :calidad_id
      t.boolean :privado_libertad
      t.boolean :libre_atraves_medida_cautelar
      t.boolean :libre_suspension_condicional_proceso
      t.datetime :fechahora_captura
      t.datetime :fechahora_puesta_a_disposicion
      t.datetime :fechahora_libertad
      t.string :observaciones
      t.string :institucion_laboral
      t.integer :estado_civil_id
      t.integer :cedula_profesional
      t.integer :numero_credencial
      t.string :especialidad
      t.integer :escolaridad_id
      t.string :ocupacion 
      t.boolean :tiene_antecedentes_penales
      t.string :antecedentes_penales_delito 
      t.integer :num_hijos
      t.boolean :tiene_padecimiento
      t.string :padecimiento_detalle
      t.integer :relacion_victima_id
      t.datetime :fecha_nac
      t.boolean :particular
      t.boolean :es_de_turno
      t.timestamps
    end

    add_index :participantes, :persona_id, :name => "participantes_persona"
    add_index :participantes, [:persona_id, :calidad_id], :name => "participantes_persona_calidad"
    add_index :participantes, [:persona_id, :tipo_participante_id], :name => "participantes_persona_tipo_participante"
    

    ### Tabla de muchos a muchos ####
    create_table :participantes_tramites, :id => false do |t|
      t.integer :participante_id
      t.integer :tramite_id
    end

    add_index "participantes_tramites", "participante_id"
    add_index "participantes_tramites", "tramite_id"

  end

  def self.down
    drop_table :participantes
    drop_table :participantes_tramites
  end
end

