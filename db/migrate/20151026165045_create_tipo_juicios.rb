class CreateTipoJuicios < ActiveRecord::Migration
  def self.up
    create_table :tipo_juicios do |t|
      t.column :materia_id, :integer
      t.column :descripcion, :string
      end
  end

  def self.down
    drop_table :tipo_juicios
  end
end
