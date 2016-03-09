class CreateCorporacionPoliciacas < ActiveRecord::Migration
  def self.up
    create_table :corporacion_policiacas do |t|
      t.column :tipo_corporacion_policiaca_id, :integer
      t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 80
      t.column :direccion, :string, :limit => 130
      t.column :telefonos, :string, :limit => 60
    end

    puts (" CREO INDICES")
    add_index :corporacion_policiacas, [:tipo_corporacion_policiaca_id], :name => "corporacion_tipo_corporacion_policiaca"
    add_index :corporacion_policiacas, [:clave], :name => "corporacion_policiaca_clave"
  end

  def self.down
    drop_table :corporacion_policiacas
  end
end
