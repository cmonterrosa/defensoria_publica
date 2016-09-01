class CreateDefensors < ActiveRecord::Migration
  def self.up
    create_table :defensors do |t|
       t.string :persona_id, :limit => 36
       t.integer :municipio_id
       t.integer :materia_id
       t.integer :cve_def
       t.boolean :activo
       t.timestamps
    end
    add_index :defensors, :persona_id, :name => "defensor_persona", :unique => true
    add_index :defensors, :municipio_id, :name => "defensor_municipio"
    add_index :defensors, :materia_id, :name => "defensor_materia_id"
  end

  def self.down
    drop_table :defensors
  end
end
