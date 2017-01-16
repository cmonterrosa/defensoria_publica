class CreateTipoPartes < ActiveRecord::Migration
  def self.up
    create_table :tipo_partes do |t|
      t.column :clave, :string, :limit => 3
      t.column :descripcion, :string, :limit => 60
    end

    execute "ALTER TABLE `tipo_partes` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"

    TipoParte.create(:clave => "ACT", :descripcion => "ACTOR") unless TipoParte.exists?(:clave => "ACT")
    TipoParte.create(:clave => "DEM", :descripcion => "DEMANDADO") unless TipoParte.exists?(:clave => "DEM")
 end

  def self.down
    drop_table :tipo_partes
  end
end
