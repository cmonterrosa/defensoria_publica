class CreateFiscalias < ActiveRecord::Migration
  def self.up
    create_table :fiscalias do |t|
      t.column :clave, :string, :limit => 10
      t.column :descripcion, :string, :limit => 100
      t.boolean :activa
    end

    add_index :fiscalias, :clave, :name => "fiscalias_clave", :unique => true
    add_index :fiscalias, :activa, :name => "fiscalias_activa"

    fiscalias="unidad central integral de investigación y justicia restaurativa Tuxtla Gutiérrez
unidad de investigación y justicia restaurativa de San Fernando
unidad de investigación y justicia restaurativa de Berriozabal
unidad de investigación y justicia restaurativa de Ocozocoautla de Espinosa
unidad de investigación y justicia restaurativa de Suchiapa
unidad de investigación y justicia restaurativa de Chiapa de Corzo
unidad de investigación y justicia restaurativa de acala
unidad de investigación y justicia restaurativa de jiquipilas
unidad de investigación y justicia restaurativa de cintalapa
unidad de investigación y justicia restaurativa de san cristobal de las casas
unidad de investigación y justicia restaurativa de teopisca
unidad de investigación y justicia restaurativa de comitán de Domínguez
unidad de investigación y justicia restaurativa de Margaritas
unidad de investigación y justicia restaurativa de Trinitaria
unidad de investigación y justicia restaurativa de villa de las rosas
unidad de investigación y justicia restaurativa de socoltenango
unidad de investigación y justicia restaurativa de tapachula
unidad de investigación y justicia restaurativa de puerto madero
unidad de investigación y justicia restaurativa de tuxtla chico
unidad de investigación y justicia restaurativa de cacahoatan
unidad de investigación y justicia restaurativa de mazatan
unidad de investigación y justicia restaurativa de ciudad hidalgo
unidad de investigación y justicia restaurativa de tonalá
unidad de investigación y justicia restaurativa de pijijiapan
unidad de investigación y justicia restaurativa de arriaga
unidad de investigación y justicia restaurativa de ocosingo
unidad de investigación y justicia restaurativa de benemerito de las Américas
unidad de investigación y justicia restaurativa de Marques de las Comillas
unidad de investigación y justicia restaurativa de San Javier
unidad de investigación y justicia restaurativa de Altamirano
unidad de investigación y justicia restaurativa de Chilón
unidad de investigación y justicia restaurativa de Bachajón
unidad de investigación y justicia restaurativa de Ostuacan
unidad de investigación y justicia restaurativa de Estación Juárez
unidad de investigación y justicia restaurativa de Reforma
unidad de investigación y justicia restaurativa de Tapilula
unidad de investigación y justicia restaurativa de Pichucalco
Unidad Central de Investigación y Justicia Restaurativa de Villaflores"

 fiscalias.each do |f|
  clave =  []
  f.strip.split(" ").each{|i| clave << i[0,1].upcase if i.size > 1 && i != 'y'}
  clave = (Fiscalia.exists?(:clave => clave.join(""))) ? nil :clave.join("")
  Fiscalia.create(:descripcion => f.strip.titleize, :clave =>  clave, :activa => true) if f.size > 0
 end
end

  def self.down
    drop_table :fiscalias
  end
end
