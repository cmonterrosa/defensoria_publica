class AddColumnMateriaAAudiencia < ActiveRecord::Migration
  def self.up
    add_column :audiencias, :materia_id, :integer
    add_index :audiencias, [:materia_id], :name => "audiencias_materia"
  end

  def self.down
    remove_column :audiencias, :materia_id
    remove_index :audiencias, :audiencias_materia
  end
end
