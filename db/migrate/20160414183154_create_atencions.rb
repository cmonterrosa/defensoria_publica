class CreateAtencions < ActiveRecord::Migration
  def self.up
    create_table :atencions do |t|
      t.column :tramite_id, :integer
      t.column :user_id, :integer
      t.column :inicio, :datetime
      t.column :fin, :datetime
      t.column :activa, :boolean
    end
    add_index :atencions, [:tramite_id, :activa], :name => "atencion_tramite_activa"
    add_index :atencions, [:user_id, :actica], :name => "atencion_tramite_activa"
  end

  def self.down
    drop_table :atencions
  end
end
