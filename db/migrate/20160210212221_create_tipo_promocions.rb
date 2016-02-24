class CreateTipoPromocions < ActiveRecord::Migration
  def self.up
    create_table :tipo_promocions do |t|
    	t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
      t.timestamps
    end

    TipoPromocion.create(:clave => "susp", :descripcion => "SOLICITUD DE SUSPENSIÓN") unless TipoAmparo.exists?(:clave => "apel")
    TipoPromocion.create(:clave => "audi", :descripcion => "SOLICITUD DE AUDIENCIA") unless TipoAmparo.exists?(:clave => "rev")
  end

  def self.down
    drop_table :tipo_promocions
  end
end
