# Modelo catalogo de los motivos por los cuales se concluye un tramite
class MotivoConclusion < ActiveRecord::Base
  has_many :concluidos
  validates_uniqueness_of :clave

  named_scope :penal, :conditions => {:materia_id => Materia.find_by_descripcion("PENAL").id}
  named_scope :nopenal, :conditions => ['materia_id  != ?', Materia.find_by_descripcion("PENAL").id]

end
