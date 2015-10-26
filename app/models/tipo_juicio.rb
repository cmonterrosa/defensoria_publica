#####################################
# Modelo que guarda los tipos de juicios que se requieren
# en materia familiar
#####################################

class TipoJuicio < ActiveRecord::Base
  belongs_to :materia
end
