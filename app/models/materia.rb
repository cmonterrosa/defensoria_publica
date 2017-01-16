##########################################
# Modelo que contiene el catálogo de materias posibles de un trámite
# 
##########################################

class Materia < ActiveRecord::Base
  has_many :tramites
  has_many :defensores

  named_scope :penal, :conditions => {:descripcion => "PENAL"}
  named_scope :nopenal, :conditions => ['descripcion  != ?', "PENAL"]
end
