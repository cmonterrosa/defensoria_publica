class CreateGuardias < ActiveRecord::Migration
  def self.up
    create_table :guardias do |t|
      t.column :persona_id, :string, :limit => 36
      t.column :inicio, :datetime
      t.column :fin, :datetime
      t.column :observaciones, :string, :limit => 140
      t.column :user_id, :integer
      t.timestamps
    end

    add_index :guardias, [:persona_id], :name => "guardias_persona"
    add_index :guardias, [:persona_id, :inicio, :fin], :name => "guardias_persona_inicio_fin"
    add_index :guardias, [:inicio, :fin], :name => "guardias_inicio_fin"
  end

  def self.down
    drop_table :guardias
  end
end
