class CreateRelacions < ActiveRecord::Migration
  def self.up
    create_table :relacions do |t|
      t.column :participante_id, :integer
      t.column :segundo_participante_id, :integer
      t.column :parentesco_id, :integer
      t.timestamps
    end
    add_index :relacions, [:participante_id, :segundo_participante_id], :name => "relacion_parentesco"
  end

  def self.down
    drop_table :relacions
  end
end
