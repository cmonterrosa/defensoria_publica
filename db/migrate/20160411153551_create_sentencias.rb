class CreateSentencias < ActiveRecord::Migration
  def self.up
    create_table :sentencias do |t|
    	t.column :clave, :string, :limit => 5
    	t.column :tramite_id, :integer
    	t.column :procedimiento_abreviado, :boolean
    	t.column :tipo_sentencia_id, :integer, :limit => 3
    	t.column :fecha, :date
    	t.column :beneficios, :string
    	t.column :juzgado_id, :integer, :limit => 3
    	t.column :instancia_id, :integer, :limit => 3
    	t.column :observaciones, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :sentencias
  end
end
