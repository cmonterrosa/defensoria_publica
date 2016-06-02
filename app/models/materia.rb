##########################################
# Modelo que contiene el catálogo de materias posibles de un trámite
# 
##########################################

class Materia < ActiveRecord::Base
  belongs_to :tramite
end
