######################################
# Modelo "participante", posee los datos de cada participante
# de una causa, y esta asociada con un objeto persona
######################################

class Participante < ActiveRecord::Base
 belongs_to :persona
 belongs_to :calidad
 has_and_belongs_to_many :tramites
end
