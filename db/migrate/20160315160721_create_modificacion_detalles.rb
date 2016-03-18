require 'rubygems'
require 'migration_comments'

class CreateModificacionDetalles < ActiveRecord::Migration
  def self.up
    create_table :modificacion_detalles do |t|
        t.column :modificacion_id, :integer, :comment => "Identificador de modificación"
        t.column :campo, :string, :limit => 60, :comment => "Columna modificada"
        t.column :old_value, :string, :comment => "valor anterior"
        t.column :value, :string, :comment => "Valor nuevo"
        t.column :tipo, :string, :comment => "Clase del comentario"
     end

    add_index :modificacion_detalles, [:modificacion_id], :name => "modificacion_detalles_id"

  end

  def self.down
    drop_table :modificacion_detalles
  end
end
