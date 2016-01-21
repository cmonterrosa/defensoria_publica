class AudienciaOral < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :tipo_audiencia
  belongs_to :organo
  belongs_to :juez

  def start_at
    fecha = DateTime.civil(self.fecha.year, self.fecha.month, self.fecha.day, self.hora, self.minutos) if self.fecha && (self.hora && self.minutos)
    return (fecha) if fecha
    return nil
  end

  def hora_completa
    case self.hora
    when (1..12)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} am"
    when (13..24)
      return "#{self.hora.to_s.rjust(2, '0')}:#{self.minutos.to_s.rjust(2, '0')} pm"
    end
  end

  def descripcion_detallada
    if self.tramite
      primera =  "<b>C.I</b> (#{self.tramite.carpeta_investigacion}) " if  self.tramite.carpeta_investigacion
      primera ||= "<b>C.P </b> (#{self.tramite.causa_penal}) " if  self.tramite.causa_penal
      primera ||= "<b>R.A </b> (#{self.tramite.registro_atencion}) " if  self.tramite.registro_atencion
      primera ||= "<b>NUC </b> (#{self.tramite.nuc}) " if  self.tramite.nuc
    end
    segunda = "<br /><b>#{self.start_at.strftime("%d de %B de %Y - %H:%M")}</b>" if self.start_at
    tercera ||= "<br /> <b>JUEZ</b>: #{self.juez.persona.nombre_completo}" if self.juez && self.juez.persona
    primera ||=  segunda ||=  tercera ||= ""
    return primera + segunda + tercera
  end

end
