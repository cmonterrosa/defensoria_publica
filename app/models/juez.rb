######################################
# Modelo que conecta a tabla de jueces
# y los vincula a registro de personas
#
######################################

class Juez < ActiveRecord::Base
  set_table_name "jueces"
  belongs_to :persona
  belongs_to :organo
  has_many :audiencia_orals

  validates_presence_of :persona_id, :message => "- Debe vincularse a una persona"
  validates_uniqueness_of :persona_id, :message => "- Ya existe un defensor con esos datos"

  def self.search(search)
    if search
      find(:all, :joins => "a, personas p", :select => "a.* ", :conditions => ['BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"], :order => "a.created_at DESC")
    else
      find(:all)
    end
  end

end
