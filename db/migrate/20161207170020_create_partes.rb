class CreatePartes < ActiveRecord::Migration
  def self.up
    create_table :partes do |t|
      t.integer :tramite_id
      t.string :persona_id, :limit => 36
      t.integer :tipo_parte_id
      t.integer :entorno_id
      t.integer :marginacion_id
      t.string :observaciones
      t.integer :estado_civil_id
      t.integer :numero_credencial
      t.integer :escolaridad_id
      t.string :ocupacion
      t.boolean :tiene_antecedentes_penales
      t.string :antecedentes_penales_delito
      t.integer :num_hijos
      t.boolean :tiene_padecimiento
      t.string :padecimiento_detalle
      t.integer :municipio_laboral
      t.integer :lengua_materna_id
      t.boolean :es_tutor
      t.timestamps
    end

    add_column :adjuntos, :parte_id, :integer
    add_index :partes, :tramite_id, :name => "partes_tramite"
    add_index :partes, :persona_id, :name => "partes_persona"

    execute "ALTER TABLE `partes` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"

  end

  def self.down
    drop_table :partes
    remove_column :adjuntos, :parte_id
  end
end
