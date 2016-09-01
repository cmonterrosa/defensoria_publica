class CreateMarginacions < ActiveRecord::Migration
  def self.up
    create_table :marginacions do |t|
    	t.column :descripcion, :string, :limit=>40 
    end
    Marginacion.create(:descripcion=>"MUY BAJA") unless Marginacion.find_by_descripcion("MUY BAJA")
    Marginacion.create(:descripcion=>"BAJA") unless Marginacion.find_by_descripcion("BAJA")
    Marginacion.create(:descripcion=>"MEDIA") unless Marginacion.find_by_descripcion("MEDIA")
    Marginacion.create(:descripcion=>"ALTA") unless Marginacion.find_by_descripcion("ALTA")
    Marginacion.create(:descripcion=>"MUY ALTA") unless Marginacion.find_by_descripcion("MUY ALTA")
  end

  def self.down
    drop_table :marginacions
  end
end
