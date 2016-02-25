######################################
# Modelo "participante", posee los datos de cada participante
# de una causa, y esta asociada con un objeto persona
######################################

class Participante < ActiveRecord::Base
 belongs_to :tramite
 belongs_to :persona
 belongs_to :calidad
 belongs_to :entorno
 belongs_to :marginacion
 belongs_to :papel
 belongs_to :tipo_participante
 has_many :relacions

  validates_presence_of :tramite_id, :message => "- Debe vincularse a un tramite"

  #validates_presence_of :persona_id, :message => "- Debe vincularse a una persona"
  

  def self.search(search,tramite)
    if search
      find(:all, :joins => "a, participantes_tramites pt, tramites t, personas p",
        :select => "a.* ",
        :conditions => ['a.id=pt.participante_id AND pt.tramite_id=t.id AND BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"],
        :order => "a.created_at DESC")
    elsif tramite
      find(:all, :joins => "a, participantes_tramites pt, tramites t, personas p",
        :conditions => ['a.id=pt.participante_id AND pt.tramite_id=t.id AND BINARY a.persona_id'],
        :select => "a.* ",  :order => "a.created_at DESC")
    else
        Array.new
    end
  end

end
