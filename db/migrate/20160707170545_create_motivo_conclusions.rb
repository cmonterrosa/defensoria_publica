class CreateMotivoConclusions < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `motivo_conclusions`;"
    create_table :motivo_conclusions do |t|
      t.column :clave, :string, :limit => 6
      t.column :descripcion, :string, :limit => 85
    end
    execute "ALTER TABLE `motivo_conclusions` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :motivo_conclusions, [:clave], :name => "motivo_conclusions_clave"
    # Valores por defecto #
    MotivoConclusion.create(:clave => "desist", :descripcion => "POR DESISTIMIENTO")
    MotivoConclusion.create(:clave => "poroto", :descripcion => "POR OTORGAMIENTO DEL PERDON DEL OFENDIDO")
    MotivoConclusion.create(:clave => "poralt", :descripcion => "POR APLICACION DE LOS MECANISMOS ALTERNATIVOS")
    MotivoConclusion.create(:clave => "porrev", :descripcion => "POR REVOCACION DE PERSONALIDAD Y ACEPTACION DE ABOGADO PARTICULAR")
    MotivoConclusion.create(:clave => "poramp", :descripcion => "POR AMPLIACION DE UNA SALIDA ALTERNA")
    MotivoConclusion.create(:clave => "porapli", :descripcion => "POR APLICACION DE CRITERIOS DE OPORTUNIDAD")
  end

  def self.down
    drop_table :motivo_conclusions
  end
end
