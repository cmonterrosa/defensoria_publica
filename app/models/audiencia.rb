require 'date'

class Audiencia < ActiveRecord::Base
  belongs_to :persona
  validates_uniqueness_of :turno, :scope => :fecha
  before_save :create_turno, :if => "self.fecha"
  

  def create_turno
    self.fecha ||= Time.now
    maximo = Audiencia.maximum(:turno, :conditions => ["fecha = ?", self.fecha])
    STDOUT.puts "Turno maximo: #{maximo}"
    self.turno ||= (maximo && maximo > 0)? maximo + 1 : 1
  end

  
end
