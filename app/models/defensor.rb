class Defensor < ActiveRecord::Base
  belongs_to :persona
  belongs_to :municipio

  validates_presence_of :persona_id, :message => "- Debe vincularse a una persona"
  validates_uniqueness_of :persona_id, :message => "- Ya existe un defensor con esos datos"

  def municipio
    (self.municipio_id) ? Municipio.find(:first, :select => "id_municipio, id_entfed, nombre", :conditions => ["id_entfed = 7 AND id_municipio = ?", self.municipio_id]) : nil
  end

  def self.search(search)
    if search
      find(:all, :joins => "a, personas p", :select => "a.* ", :conditions => ['BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"], :order => "a.created_at DESC")
    else
      find(:all)
    end
  end

end
