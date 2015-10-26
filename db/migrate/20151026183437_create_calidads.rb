class CreateCalidads < ActiveRecord::Migration
  def self.up
    create_table :calidads do |t|
    	t.column :descripcion, :string, :limit=>40		
    end

    #Se agregan los datos del catálog de calidad 
    Calidad.create(:descripcion=>"DETENIDO") unless Calidad.find_by_descripcion("DETENIDO")
    Calidad.create(:descripcion=>"IMPUTADO") unless Calidad.find_by_descripcion("IMPUTADO")
    
  end

  def self.down
    drop_table :calidads
  end
end
