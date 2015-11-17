class CreateAmparos < ActiveRecord::Migration
  def self.up
    create_table :amparos do |t|
      t.column :tramite_id, :integer
      t.column :fecha, :date
      t.column :tipo_amparo_id, :integer
      t.column :descripcion, :string, :limit => 100
      t.column :observaciones, :string, :limit => 120
      t.column :user_id, :integer
      t.timestamps
    end

   add_index :amparos, [:tramite_id], :name => "amparos_tramite"
   add_index :amparos, [:fecha], :name => "amparos_fecha"
  end

  def self.down
    drop_table :amparos
  end
end
