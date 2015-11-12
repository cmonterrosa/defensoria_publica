class CreateEntornos < ActiveRecord::Migration
  def self.up
    create_table :entornos do |t|
    	t.column :descripcion, :string, :limit => 40	      
    end

    Entorno.create(:descripcion => "RURAL")  unless Entorno.exists?(:descripcion => "RURAL")
    Entorno.create(:descripcion => "URBANO")  unless Entorno.exists?(:descripcion => "URBANO")

  end

  def self.down
    drop_table :entornos
  end
end
