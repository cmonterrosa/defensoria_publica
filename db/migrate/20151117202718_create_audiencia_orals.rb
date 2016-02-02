class CreateAudienciaOrals < ActiveRecord::Migration
  def self.up
    create_table :audiencia_orals do |t|
      t.column :tramite_id, :integer
      t.column :fecha, :date
      t.column :hora, :integer
      t.column :minutos, :integer
      t.column :tipo_audiencia_id, :integer
      t.column :organo_id, :integer
      t.column :juez_id, :integer
      t.column :defensor_id, :integer
      t.column :sala, :string, :limit => 20
      t.column :sentencia_dictada, :string
      t.column :descripcion, :string, :limit => 100
      t.column :observaciones, :string, :limit => 120
      t.column :cancel, :boolean
      t.column :cancel_user, :integer
      t.timestamps
    end
    
    add_index :audiencia_orals, [:tramite_id], :name => ["audiencias_orales_tramite"]
    add_index :audiencia_orals, [:fecha, :hora, :minutos, :organo_id], :name => ["audiencias_orales_fecha_hora_minutos_organo"]
    add_index :audiencia_orals, [:organo_id], :name => ["audiencias_orales_organo"]
    add_index :audiencia_orals, [:juez_id], :name => ["audiencias_orales_juez"]
  end

  def self.down
    drop_table :audiencia_orals
  end
end
