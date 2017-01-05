class CreateTipoJuicios < ActiveRecord::Migration
  def self.up
    create_table :tipo_juicios do |t|
      t.column :materia_id, :integer
      t.column :clave, :string, :limit => 6
      t.column :descripcion, :string, :limit => 80
      end
  end

  def self.down
    drop_table :tipo_juicios
  end
end
