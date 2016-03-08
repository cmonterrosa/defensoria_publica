class CreatePromocions < ActiveRecord::Migration
  def self.up
    create_table :promocions do |t|
    	t.column :tramite_id, :integer
      t.column :fecha, :date 
      t.column :titulo, :string, :limit => 120
    	t.column :descripcion, :string
      t.column :tipo_promocion_id, :integer
      t.column :contestacion_id, :integer    	
      t.timestamps
    end

    add_index :promocions, [:tramite_id], :name => "promocions_tramite"

  end

  def self.down
    drop_table :promocions
  end
end
