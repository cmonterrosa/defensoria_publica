class CreateAudienciaOrals < ActiveRecord::Migration
  def self.up
    create_table :audiencia_orals do |t|
      t.column :fecha, :date
      t.column :hora, :integer
      t.column :minutos, :integer
      t.column :descripcion, :string, :limit => 100
      t.column :observaciones, :string, :limit => 120
      t.column :notificacion, :boolean
      t.column :cancel, :boolean
      t.column :cancel_user, :integer
      t.column :juzgado_id, :integer
      t.timestamps
    end

    add_index :audiencia_orals, [:fecha, :hora], :name => ["audiencias_orales_fecha_hora"]
    add_index :audiencia_orals, [:juzgado_id], :name => ["audiencias_orales_juzgado"]
  end

  def self.down
    drop_table :audiencia_orals
  end
end
