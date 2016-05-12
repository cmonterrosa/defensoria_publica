######################################
# Modelo interno de materias
# 
######################################

class Materia < ActiveRecord::Base
  belongs_to :tramite
end
