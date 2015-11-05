class CreateAusencias < ActiveRecord::Migration
  def self.up
    create_table :ausencias do |t|
      t.column :persona_id, :string, :limit => 36
      t.column :motivo_ausencia_id, :integer
      t.column :inicio, :datetime
      t.column :fin, :datetime
      t.column :observaciones, :string, :limit => 140
      t.column :activo, :boolean
      t.column :user_id, :integer
      t.timestamps
    end

    add_index :ausencias, [:persona_id], :name => "ausencias_persona"
    add_index :ausencias, [:persona_id, :motivo_ausencia_id], :name => "ausencias_persona_motivo"
    add_index :ausencias, [:persona_id, :inicio, :fin], :name => "ausencias_persona_inicio_fin"
end

  def self.down
    drop_table :ausencias
  end
end
