class CreateAmparos < ActiveRecord::Migration
  def self.up
    create_table :amparos do |t|
      t.column :tramite_id, :integer
      t.column :num_amparo, :string, :limit => 40
      t.column :fecha, :date

      # Categorización
      t.column :accion_amparo_id, :integer
      t.column :tipo_amparo_id, :integer
      t.column :fase_amparo_id, :integer
      t.column :sentido_resolucion_amparo_id, :integer
      
      # Datos Generales
      t.column :descripcion, :string, :limit => 100
      t.column :observaciones, :string, :limit => 120

      # Tracking
      t.column :user_id, :integer
      t.timestamps
    end

   add_index :amparos, [:tramite_id], :name => "amparos_tramite"
   add_index :amparos, [:fecha], :name => "amparos_fecha"
   add_index :amparos, [:num_amparo], :name => "amparos_numamparo"

  end

  def self.down
    drop_table :amparos
  end
end
