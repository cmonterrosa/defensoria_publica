class CreateMecanismoAlternativos < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `mecanismo_alternativos`;"
    create_table :mecanismo_alternativos do |t|
    	t.column :tramite_id, :integer
    	t.column :fecha, :date 
    	t.column :lugar, :string
    	t.column :especialista, :string
    	t.column :tipo_mecanismo_id, :integer 
    	t.column :descripcion_resultado, :string    	    	
      t.timestamps
    end
    execute "ALTER TABLE `mecanismo_alternativos` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
  end

  def self.down
    drop_table :mecanismo_alternativos
  end
end
