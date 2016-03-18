class ModificacionDetalle < ActiveRecord::Base
  belongs_to :modificacion

  
 def descripcion_campo(campo)
    (self.class.find_by_sql("SELECT a.COLUMN_COMMENT AS comment
    FROM information_schema.COLUMNS a
    WHERE a.TABLE_NAME = '#{self.class.table_name}' AND
   a.COLUMN_NAME='#{campo}';").first.comment) if campo
 end

 


end
