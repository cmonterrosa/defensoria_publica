class CreateClaveElectors < ActiveRecord::Migration
  def self.up
    create_table :clave_electors do |t|
      t.string :persona_id, :limit => 36
      t.column :descripcion, :string, :limit => 18
      t.timestamps
    end
    add_index :clave_electors, [:persona_id], :name => "persona_clave_elector"
  end

  def self.down
    drop_table :clave_electors
  end
end
