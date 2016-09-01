class CreateConcluidos < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `concluidos`;"
    create_table :concluidos do |t|
        t.column :user_id, :integer
        t.column :tramite_id, :integer
        t.column  :motivo_conclusion_id, :integer
        t.column  :observaciones_conclusion, :string
        t.timestamps
    end
    execute "ALTER TABLE `concluidos` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    add_index :concluidos, [:tramite_id], :name => "concluidos_tramite"
    add_index :concluidos, [:user_id], :name => "concluidos_user"
  end

  def self.down
    drop_table :concluidos
  end
end
