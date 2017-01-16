class CreateSentidoResolucionAmparos < ActiveRecord::Migration
  def self.up
    create_table :sentido_resolucion_amparos do |t|
      t.string :clave, :limit => 4
      t.string :descripcion, :limit => 40
    end

    execute "ALTER TABLE `sentido_resolucion_amparos` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"

    add_index :sentido_resolucion_amparos, [:clave], :unique => true

    SentidoResolucionAmparo.create(:clave => "DEEX", :descripcion => "DESECHADO POR EXTEMPORÁNEO")
    SentidoResolucionAmparo.create(:clave => "SOBR", :descripcion => "SOBRESEE")
    SentidoResolucionAmparo.create(:clave => "NIEG", :descripcion => "NIEGA")
    SentidoResolucionAmparo.create(:clave => "OTOL", :descripcion => "OTORGADO (LISO Y LLANO)")
    SentidoResolucionAmparo.create(:clave => "OTOE", :descripcion => "OTORGADO (PARA EFECTOS)")

  end

  def self.down
    drop_table :sentido_resolucion_amparos
  end
end
