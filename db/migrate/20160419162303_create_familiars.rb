class CreateFamiliars < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `familiars`;"
    create_table :familiars do |t|
    	t.column :persona_id, :string
    	t.column :nombre, :string, :limit => 60
      t.column :apellidos, :string, :limit => 80
      t.column :vive, :boolean
    	t.column :tipo_familiar_id, :integer
      t.timestamps
    end
    execute "ALTER TABLE `familiars` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :familiars, [:persona_id, :tipo_familiar_id], :name => "familiars_persona_tipo_familiar"
end

  def self.down
    drop_table :familiars
    execute "DROP TABLE IF EXISTS `familiars`;"
  end
end
