class CreateSentencias < ActiveRecord::Migration
  def self.up
    create_table :sentencias do |t|
    	t.column :clave, :string, :limit => 5
    	t.column :tramite_id, :integer
    	t.column :procedimiento_abreviado, :boolean
    	t.column :tipo_sentencia_id, :integer
    	t.column :fecha, :date
    	t.column :beneficios, :boolean 
    	t.column :organo_id, :integer
    	t.column :instancia_id, :integer
    	t.column :observaciones, :string
      t.column :procedente, :boolean
      t.column :apelada, :boolean
      t.timestamps
    end
    add_index :sentencias, [:tramite_id], :name => "sentencias_tramite"
    add_index :sentencias, [:procedente], :name => "sentencias_procedente"
  end

  def self.down
    drop_table :sentencias
  end
end
