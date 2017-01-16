###################################
# = Modelo que contiene adscripciones
###################################

class Adscripcion < ActiveRecord::Base
  has_many :audiencias
  has_many :users, :conditions => "activo = true"

  def defensores
      puts users = User.find(:all, :conditions => ["adscripcion_id = ?", self.id])
      return Defensor.find(:all, :conditions => ["persona_id in (?)", users.map{|i|i.persona_id}])
  end

end
