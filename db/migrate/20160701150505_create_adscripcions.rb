class CreateAdscripcions < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `adscripcions`;"
    create_table :adscripcions do |t|
      t.string :clave, :limit => 6
      t.string :descripcion, :limit => 120
    end

    add_index :adscripcions, [:clave], :unique => true
    execute "ALTER TABLE `adscripcions` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"

    Adscripcion.reset_column_information
    Adscripcion.create(:clave => "digene", :descripcion => "DIRECCION GENERAL DEL INSTITUTO DE DEFENSORIA PÚBLICA")
    Adscripcion.create(:clave => "sugene", :descripcion => "SUBDIRECCION GENERAL DEL INSTITUTO DE  DEFENSORIA PÚBLICA")
    Adscripcion.create(:clave => "suream", :descripcion => "SUBDIRECCION REGIONAL DEL INSTITUTO  DEFENSORIA PÚBLICA EN 'EL AMATE'")
    Adscripcion.create(:clave => "suresc", :descripcion => "SUBDIRECCION REGIONAL DEL INSTITUTO  DEFENSORIA PÚBLICA EN 'SAN CRISTOBAL'")
    Adscripcion.create(:clave => "suretp", :descripcion => "SUBDIRECCION REGIONAL ZONA COSTA DEL INSTITUTO  DEFENSORIA PÚBLICA EN 'TAPACHULA'")
  end

  def self.down
    drop_table :adscripcions
  end
end
