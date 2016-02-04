class CreatePromocions < ActiveRecord::Migration
  def self.up
    create_table :promocions do |t|
    	t.column :tramite_id, :integer
      t.column :fecha, :date 
      t.column :titulo, :string
    	t.column :descripcion, :string
      t.status :tipo_promocion, :integer
      t.column :resolucion, :contestacion_id    	

      t.timestamps
    end

    add_index :promocions, [:tramite_id], :name => "promocions_tramite"

  end

  def self.down
    drop_table :promocions
  end
end
