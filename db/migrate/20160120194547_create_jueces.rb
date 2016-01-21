class CreateJueces < ActiveRecord::Migration
  def self.up
    create_table :jueces do |t|
       t.string :persona_id, :limit => 36
       t.integer :organo_id
       t.string :observaciones, :limit => 255
       t.boolean :activo
       t.timestamps
    end
    add_index :jueces, :persona_id, :name => "juez_persona", :unique => true
    add_index :jueces, [:organo_id, :activo], :name => "juez_organo_activo"
  end

  def self.down
    drop_table :jueces
  end
end
