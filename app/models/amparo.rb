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

  before_destroy :destroy_adjuntos

  def destroy_adjuntos
      self.adjunto.destroy if self.adjunto
  end

end
