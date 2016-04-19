class AudienciaOral < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :tipo_audiencia
  belongs_to :organo
  belongs_to :juez
  belongs_to :defensor

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
      primera =  "<b>C.I</b> (#{self.tramite.carpeta_investigacion}) " if  self.tramite.carpeta_investigacion && self.tramite.carpeta_investigacion.size > 0
      primera ||= "<b>C.P </b> (#{self.tramite.causa_penal}) " if  self.tramite.causa_penal &&  self.tramite.causa_penal.size > 0
      primera ||= "<b>R.A </b> (#{self.tramite.registro_atencion}) " if  self.tramite.registro_atencion && self.tramite.registro_atencion.size > 0
      primera ||= "<b>NUC </b> (#{self.tramite.nuc}) " if  self.tramite.nuc && self.tramite.nuc.size > 0
    end
    primera ||= ""
    segunda = "<br /><b>#{self.start_at.strftime("%d de %B de %Y - %H:%M %p")}</b>" if self.start_at
    segunda ||= ""
    tercera ||= "<br /> <b>JUEZ</b>: #{self.juez.persona.nombre_completo}" if self.juez && self.juez.persona
    tercera ||= ""
    return primera + segunda + tercera
  end

  def self.search(search)
    if search
      find(:all, :joins => "a, personas p", :select => "a.* ", :conditions => ['BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"], :order => "a.created_at DESC")
    else
      find(:all)
    end
  end

  def cancelar(usuario=nil)
   usuario ||= self.cancel_user
   self.update_attributes!(:cancel => true, :cancel_user => usuario)
  end

  def reactivar
    self.update_attributes!(:cancel => nil, :cancel_user => nil)
  end

  def usuario_cancelacion
    if self.cancel_user
      if u = User.find(self.cancel_user)
         u.persona
      end
    end
  end

end
