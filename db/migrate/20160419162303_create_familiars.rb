class CreateFamiliars < ActiveRecord::Migration
  def self.up
    create_table :familiars do |t|
    	t.column :persona_id, :string
    	t.column :nombre, :string
    	t.column :apellido_paterno, :string
    	t.column :apellido_materno, :string
    	t.column :vive, :boolean
    	t.column :tipo_familiar_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :familiars
  end
end
