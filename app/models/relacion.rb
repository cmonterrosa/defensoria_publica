#########################################
# Este modelo establece la relacion entre los participantes
#
#########################################

class Relacion < ActiveRecord::Base
    belongs_to :participante

  def parentesco
    Catalogo.parentesco.find(self.parentesco_id) if self.parentesco_id
  end

  def segundo_participante
      Participante.find(self.segundo_participante_id) if self.segundo_participante_id
  end
end