class CreateAdjuntos < ActiveRecord::Migration
  def self.up
    create_table :adjuntos do |t|
      t.string :descripcion, :limit => 160
      t.string :file_name, :limit => 120
      t.string :file_size, :limit => 25
      t.string :file_type, :limit => 40
      t.integer :tramite_id
      t.integer :participante_id
      t.integer :user_id
      t.string :md5, :limit => 32
      t.timestamps
    end
     add_index :adjuntos, [:tramite_id], :name => "adjuntos_tramite"
     add_index :adjuntos, [:participante_id], :name => "adjuntos_participante"
     add_index :adjuntos, [:user_id], :name => "adjuntos_user"
  end

  def self.down
    drop_table :adjuntos
  end
end
