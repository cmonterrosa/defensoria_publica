####################################################
# = Orientaciones presenciales en el Instituto de la Defensoría Pública
#
####################################################

require 'date'

class Audiencia < ActiveRecord::Base
  belongs_to :persona
  belongs_to :defensor
  belongs_to :adscripcion
  belongs_to :user
  before_save :set_fecha

  validates_uniqueness_of :turno, :scope => [:fecha, :adscripcion_id], :message => "Valor repetido"

  before_save :create_turno, :if => "self.fechahora_atencion"


  # Establece fecha por defecto
  def set_fecha
    self.fecha ||= self.fechahora_atencion if self.fechahora_atencion
  end

  # Genera el consecutivo del turno del dia actual
  def create_turno
    unless self.turno
      self.fecha ||= Time.now
      maximo = Audiencia.maximum(:turno, :conditions => ["adscripcion_id = ? AND DATE(fechahora_atencion) = ?", self.adscripcion_id, self.fechahora_atencion.strftime("%y/%m/%d'")])
      STDOUT.puts "Registro nuevo de Turno maximo: #{maximo}"
      self.turno ||= (maximo && maximo > 0)? maximo + 1 : 1
    end
  end

  # Metodo de busqueda
  def self.search(search, user)
    if user && user.adscripcion
      adscripciones = (user.has_role?(:directivo))? Adscripcion.all.collect{|i|i.id} : user.adscripcion.id
      if search
         @resultados = Persona.search(search)
         find(:all, :conditions => ["adscripcion_id in (?) AND persona_id in (?)", adscripciones, @resultados.map{|i| i.id}],  :order => "fechahora_atencion") if @resultados && !@resultados.empty?
         #find(:all, :joins => "a, personas p", :select => "a.* ", :conditions => ['adscripcion_id in (?) AND BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', adscripciones, "%#{search}%"], :order => "a.fecha, a.turno")
      else
        #find(:all)
      end
    end
  end
end
