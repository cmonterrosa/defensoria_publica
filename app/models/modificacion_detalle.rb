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
  
 def descripcion_campo(campo)
    (self.class.find_by_sql("SELECT a.COLUMN_COMMENT AS comment
    FROM information_schema.COLUMNS a
    WHERE a.TABLE_NAME = '#{self.class.table_name}' AND
   a.COLUMN_NAME='#{campo}';").first.comment) if campo
 end
end
