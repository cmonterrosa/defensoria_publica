class CreateFaseAmparos < ActiveRecord::Migration
  def self.up
    create_table :fase_amparos do |t|
      t.string :clave, :limit => 4
      t.string :descripcion, :limit => 40
    end

    execute "ALTER TABLE `fase_amparos` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :fase_amparos, [:clave], :unique => true

    FaseAmparo.create(:clave => "EREV", :descripcion => "EN REVISION")
    FaseAmparo.create(:clave => "EQUE", :descripcion => "EN QUEJA")
    FaseAmparo.create(:clave => "EREC", :descripcion => "EN RECLAMACIÓN")

  end

  def self.down
    drop_table :fase_amparos
  end
end
