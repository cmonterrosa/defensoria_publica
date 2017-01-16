############################################
# Modelo para guardar amparos
# 
#
############################################

class Amparo < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :accion_amparo
  belongs_to :tipo_amparo
  belongs_to :fase_amparo
  belongs_to :sentido_resolucion_amparo
  has_one :adjunto
end
