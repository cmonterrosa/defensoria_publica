class Persona <  ActiveResource::Base
  self.site = "http://172.20.60.20:3001/"
  self.user = "user"
  self.password = "secret"
  self.element_name = "persona"

  set_primary_key "id_persona"
  #self.format = :j

  def self.find_by_curp(curp)
    Persona.get(:show_by_curp, :curp => curp) if curp
  end


  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end
end
