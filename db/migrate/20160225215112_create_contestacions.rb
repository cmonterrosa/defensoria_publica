class CreateContestacions < ActiveRecord::Migration
  def self.up
    create_table :contestacions do |t|
    	t.column :clave, :string, :limit => 5
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    Contestacion.create(:clave => "esper", :descripcion => "En espera") unless Contestacion.exists?(:clave => "esper")
    Contestacion.create(:clave => "apro", :descripcion => "Aprobada") unless Contestacion.exists?(:clave => "apro")
    Contestacion.create(:clave => "rchzd", :descripcion => "Rechazada") unless Contestacion.exists?(:clave => "rchzd")

  end

  def self.down
    drop_table :contestacions
  end
end
