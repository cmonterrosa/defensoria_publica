class CreateEstatus < ActiveRecord::Migration
  def self.up
    create_table :estatus do |t|
      t.column :clave, :string, :limit => 6
      t.column :descripcion, :string, :limit => 80
      t.column :concluido, :boolean
      t.timestamps
    end

    add_column :tramites, :estatu_id, :integer
    add_index :tramites, :estatu_id, :name => "tramite_estatu"
  end

  def self.down
    drop_table :estatus
    remove_index :tramites, :tramite_estatu
    remove_column :tramites, :estatu_id
  end
end
