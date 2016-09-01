# Modelo catalogo de los motivos por los cuales se concluye un tramite
class MotivoConclusion < ActiveRecord::Base
  has_many :concluidos
  validates_uniqueness_of :clave
end
