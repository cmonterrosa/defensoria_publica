class CreateExtensionPersonas < ActiveRecord::Migration
  def self.up
    create_table :extension_personas do |t|
      t.string :persona_id, :limit => 36
      t.integer :sexo_id
      t.integer :idioma_id
      t.timestamps
    end

    add_index :extension_personas, :persona_id, :name => "extension_personas_persona"
  end

  def self.down
    drop_table :extension_personas
  end
end
