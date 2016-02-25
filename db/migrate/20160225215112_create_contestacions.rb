class CreateContestacions < ActiveRecord::Migration
  def self.up
    create_table :contestacions do |t|
    	t.column :clave, :string, :limit => 5
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    Contestacion.create(:clave => "esper", :descripcion => "En espera") unless TipoAmparo.exists?(:clave => "liso")
    Contestacion.create(:clave => "apro", :descripcion => "Aprobada") unless TipoAmparo.exists?(:clave => "llano")
    Contestacion.create(:clave => "rchzd", :descripcion => "Rechazada") unless TipoAmparo.exists?(:clave => "dire")

  end

  def self.down
    drop_table :contestacions
  end
end
