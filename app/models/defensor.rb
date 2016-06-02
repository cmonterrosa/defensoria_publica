#####################################################
# = Modelo de defensores públicos
#
#####################################################
require 'date'
class Defensor < ActiveRecord::Base
  belongs_to :persona
  belongs_to :municipio
  validates_presence_of :persona_id, :message => "- Debe vincularse a una persona"
  validates_uniqueness_of :persona_id, :message => "- Ya existe un defensor con esos datos"

  # Regresa el objeto municipio vinculado al defensor público
  def municipio
    (self.municipio_id) ? Municipio.find(:first, :select => "id_municipio, id_entfed, nombre", :conditions => ["id_entfed = 7 AND id_municipio = ?", self.municipio_id]) : nil
  end

  # Búsqueda de defensores públicos
  def self.search(search)
    if search
      find(:all, :joins => "a, personas p", :select => "a.* ", :conditions => ['BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"], :order => "a.created_at DESC")
    else
      find(:all)
    end
  end

  # Trámites en los cuales el defensor participó en período de tiempo establecido
  def num_tramites_periodo(inicio=Time.now,fin=Time.now)
       inicio = inicio.strftime("%Y-%m-%d %H:%M:%S")
       fin = fin.strftime("%Y-%m-%d %H:%M:%S")
       num_tramites= Tramite.count(:id, :conditions => ["defensor_id = ? AND (fechahora_atencion between ? AND ?)", self.id, inicio, fin]) if inicio && fin
       return num_tramites
  end

  # Regresa el número de trámites en los cuales ha intervenido un defensor desde el primer minuto de la semana actual
  def actividad_desde_inicio_semana
      now = DateTime.parse(Time.now.strftime("%Y-%m-%d") + " 00:00:01")
      inicio_semana = DateTime.parse((now - (now.wday-1)).strftime("%Y-%m-%d") + " 00:00:01")
      fin_semana = DateTime.parse((now + (6-now.wday)).strftime("%Y-%m-%d") + " 23:59:59")
      return num_tramites_periodo(inicio_semana,fin_semana)
  end


end
