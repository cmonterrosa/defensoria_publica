class CreateRecursos < ActiveRecord::Migration
  def self.up
    create_table :recursos do |t|
    	t.column :tramite_id, :integer
      t.column :tipo_recurso_id, :integer
      t.column :fecha, :date
      t.column :descripcion, :string, :limit => 100
      t.column :admitido, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :recursos
  end
end
