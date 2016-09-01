class CreateMensajes < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `mensajes`;"
    create_table :mensajes do |t|
      t.string :clave, :limit => 6
      t.integer :envia_id
      t.integer :recibe_id
      t.string :asunto, :limit => 120
      t.string :descripcion
      t.integer :activo
      t.datetime :leido_at
      t.integer :owner_id
      t.timestamps
    end
    execute "ALTER TABLE `mensajes` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"

   add_column :adjuntos, :clave_mensaje, :string, :limit => 6
   add_index :adjuntos, [:clave_mensaje], :name => "adjuntos_clave_mensaje"
   add_index :mensajes, [:clave], :name => "mensajes_clave"
   add_index :mensajes, [:envia_id, :owner_id], :name => "mensajes_usuario_envio"
   add_index :mensajes, [:recibe_id, :owner_id], :name => "mensajes_usuario_recibido"
  end

  def self.down
    drop_table :mensajes
    remove_column :adjuntos, :clave_mensaje
  end
end
