class CreatePapels < ActiveRecord::Migration
  def self.up
    create_table :papels do |t|
      t.column :descripcion, :string, :limit => 40
    end

    Papel.create(:descripcion => "VICTIMA")  unless Papel.exists?(:descripcion => "VICTIMA")
    Papel.create(:descripcion => "OFENDIDO") unless Papel.exists?(:descripcion => "OFENDIDO")
  end

  def self.down
    drop_table :papels
  end
end
