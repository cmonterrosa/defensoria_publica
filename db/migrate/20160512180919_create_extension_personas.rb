class CreateExtensionPersonas < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `extension_personas`;"
    create_table :extension_personas do |t|
      t.string :persona_id, :limit => 36
      t.integer :sexo_id
      t.integer :idioma_id
      t.integer :origen_id
      t.integer :entorno_id
      t.integer :marginacion_id
      t.timestamps
    end
    execute "ALTER TABLE `extension_personas` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :extension_personas, :persona_id, :name => "extension_personas_persona"
  end

  def self.down
    drop_table :extension_personas
  end
end
