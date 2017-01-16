class CreateMotivoConclusions < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `motivo_conclusions`;"
    create_table :motivo_conclusions do |t|
      t.column :clave, :string, :limit => 6
      t.column :materia_id, :integer
      t.column :descripcion, :string, :limit => 85
    end
    execute "ALTER TABLE `motivo_conclusions` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :motivo_conclusions, [:clave], :name => "motivo_conclusions_clave", :unique => true
    # Valores por defecto #

    penal = Materia.find_by_descripcion("PENAL")
    familiar = Materia.find_by_descripcion("FAMILIAR")

    # Penal
    MotivoConclusion.create(:materia_id => penal.id, :clave => "desist", :descripcion => "POR DESISTIMIENTO")
    MotivoConclusion.create(:materia_id => penal.id, :clave => "poroto", :descripcion => "POR OTORGAMIENTO DEL PERDON DEL OFENDIDO")
    MotivoConclusion.create(:materia_id => penal.id, :clave => "poralt", :descripcion => "POR APLICACION DE LOS MECANISMOS ALTERNATIVOS")
    MotivoConclusion.create(:materia_id => penal.id, :clave => "porrev", :descripcion => "POR REVOCACION DE PERSONALIDAD Y ACEPTACION DE ABOGADO PARTICULAR")
    MotivoConclusion.create(:materia_id => penal.id, :clave => "poramp", :descripcion => "POR AMPLIACION DE UNA SALIDA ALTERNA")
    MotivoConclusion.create(:materia_id => penal.id, :clave => "porapli", :descripcion => "POR APLICACION DE CRITERIOS DE OPORTUNIDAD")

    # Familiar
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "porsen", :descripcion => "POR SENTENCIA")
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "porcon", :descripcion => "POR CONVENIO")
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "porfal", :descripcion => "POR INACTIVIDAD A FALTA DE INTERÉS")
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "testim", :descripcion => "POR TESTIMONIALES")
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "porrev", :descripcion => "POR REVOCACION DE PERSONALIDAD Y ACEPTACION DE ABOGADO PARTICULAR")
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "desisf", :descripcion => "POR DESISTIMIENTO")
    MotivoConclusion.create(:materia_id => familiar.id, :clave => "porcad", :descripcion => "POR CADUCIDAD DE LA ACCIÓN")
  end

  def self.down
    drop_table :motivo_conclusions
  end
end
