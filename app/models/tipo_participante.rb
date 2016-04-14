class TipoParticipante < ActiveRecord::Base
  has_many :participantes

 def default_partial
  case self.clave
    when "MPTU"
    ## Ministerio publico de turno ##
      return "ministerio_publico"
    when "MPTR"
    ## Ministerio publico de tramite ##
      return "ministerio_publico"
    when "ASEJ"
    ## Asesor juridico ##
      return "ministerio_publico"
    when "DEPU"
    ## Defensor privado ##
      return "defensor"
    when "PERO"
    ## Perito oficial ##
      return "perito"
    when "PERP"
    ## Perito privado ##
      return "perito"
    when "POLI"
    ## Policia público o privado ##
      return "policia"
    when "VICT"
    ## Victima ##
      return "victima"
    when "ACU"
    ## Acusado ##
      return "acusado"
    when "TEST"
    ## Testigo ##
      return "testigo"
    when "DEPR"
    ## Defensor privado ##
      return "defensor_privado"
    end if self.clave
  end

end
