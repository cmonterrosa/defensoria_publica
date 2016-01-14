class AudienciaOral < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :tipo_audiencia

  def start_at
    fecha = DateTime.civil(self.fecha.year, self.fecha.month, self.fecha.day, self.hora, self.minutos) if self.fecha && (self.hora && self.minutos)
    return (fecha) if fecha
    return nil
  end

end
