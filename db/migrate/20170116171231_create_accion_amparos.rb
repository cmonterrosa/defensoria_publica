class CreateAccionAmparos < ActiveRecord::Migration
  def self.up
    create_table :accion_amparos do |t|
      t.string :clave, :limit => 4
      t.string :descripcion, :limit => "60"
    end

    execute "ALTER TABLE `accion_amparos` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"

    add_index :accion_amparos, [:clave], :unique => true
   
    AccionAmparo.create(:clave => "PROR", :descripcion => "PROMOVIDO Y RESUELTO")
    AccionAmparo.create(:clave => "RECU", :descripcion => "RECURRIDO")
  end

  def self.down
    drop_table :accion_amparos
  end
end
