####################################################
# Modelo que guarda detalle de cada campo modificado en los modelos especificados
#
####################################################

class ModificacionDetalle < ActiveRecord::Base
  belongs_to :modificacion
  before_save :check_id
  validates_uniqueness_of :id
  validates_presence_of :modificacion_id, :if => "self.id"

  def check_id
    unless self.id
        maximo=  self.class.maximum(:id)
        id = 1 unless maximo
        id ||= maximo.to_i + 1
        self.id = id
     end
  end
  
 def field_comment(field)
    (self.class.find_by_sql("SELECT a.COLUMN_COMMENT AS comment
    FROM information_schema.COLUMNS a
    WHERE a.TABLE_NAME = '#{self.class.table_name}' AND
   a.COLUMN_NAME='#{field}';").first.comment) if field
 end

 def valor_anterior
  if self.campo =~ /\w+id$/ && self.old_value
     row = eval("#{self.campo.gsub("_id", "").camelize}.find(#{self.old_value})")
     va =  (row && row.respond_to?(:descripcion)) ? row.descripcion : nil
     va ||= (row && row.respond_to?(:persona_id)) ? row.persona.nombre_completo : self.old_value
     return va
  else
      return self.old_value
  end
 end

 def valor_nuevo
   if self.campo =~ /\w+id$/ && self.value
     row = eval("#{self.campo.gsub("_id", "").camelize}.find(#{self.value})")
     vn = (row && row.respond_to?(:descripcion)) ? row.descripcion : nil
     vn ||= (row && row.respond_to?(:persona_id)) ? row.persona.nombre_completo : self.value
     return vn
  else
      return self.value
  end
 end

end
