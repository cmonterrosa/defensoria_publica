require 'date'

class Audiencia < ActiveRecord::Base
  belongs_to :persona

  before_save :create_turno, :if => "self.fechahora_solicitud"
  

  def create_turno
    maximo = Audiencia.maximum(:turno, :conditions => ["fechahora_solicitud between ? AND ?", "#{self.fechahora_solicitud.strftime('%Y-%m-%d 00:00:01')}", "#{self.fechahora_solicitud.strftime('%Y-%m-%d 23:59:59')}"])
    STDOUT.puts "Turno maximo: #{maximo}"
    self.turno ||= (maximo && maximo > 0)? maximo + 1 : 1
  end

  
end
