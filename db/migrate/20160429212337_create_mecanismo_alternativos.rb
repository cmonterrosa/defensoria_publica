class CreateMecanismoAlternativos < ActiveRecord::Migration
  def self.up
    create_table :mecanismo_alternativos do |t|
    	t.column :tramite_id, :integer
    	t.column :fecha, :date 
    	t.column :lugar, :string
    	t.column :especialista, :string
    	t.column :tipo_mecanismo_id, :integer 
    	t.column :descripcion_resultado, :string    	    	
      t.timestamps
    end
  end

  def self.down
    drop_table :mecanismo_alternativos
  end
end
