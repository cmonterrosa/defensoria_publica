class CreateAtencions < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `atencions`;"
    create_table :atencions do |t|
      t.column :tramite_id, :integer
      t.column :user_id, :integer
      t.column :inicio, :datetime
      t.column :fin, :datetime
      t.column :activa, :boolean
    end
    execute "ALTER TABLE `atencions` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :atencions, [:tramite_id, :activa], :name => "atencion_tramite_activa"
    add_index :atencions, [:user_id, :actica], :name => "atencion_tramite_activa"
  end

  def self.down
    drop_table :atencions
  end
end
