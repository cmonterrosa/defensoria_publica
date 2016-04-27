class CreateFamiliars < ActiveRecord::Migration
  def self.up
    create_table :familiars do |t|
    	t.column :persona_id, :string
    	t.column :nombre, :string, :limit => 60
      t.column :apellidos, :string, :limit => 80
      t.column :vive, :boolean
    	t.column :tipo_familiar_id, :integer
      t.timestamps
    end
    add_index :familiars, [:persona_id], :name => "familiars_persona"
end

  def self.down
    drop_table :familiars
  end
end
