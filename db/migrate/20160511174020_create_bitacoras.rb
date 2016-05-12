class CreateBitacoras < ActiveRecord::Migration
  def self.up
    create_table :bitacoras do |t|
      t.column :tramite_id, :integer
      t.column :estatu_id, :integer
      t.timestamps
    end
    add_index :bitacoras, [:tramite_id], :name => "bitacora_tramite"
  end

  def self.down
    drop_table :bitacoras
  end
end
