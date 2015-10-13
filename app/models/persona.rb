class Persona <  ActiveResource::Base
  self.site = "http://localhost:3001/"
  self.user = "user"
  self.password = "secret"
  self.element_name = "persona"

  set_primary_key "id_persona"
  
  def self.find_by_curp(curp)
      Persona.get(:show_by_curp, :curp => curp) if curp
  end

  def self.find_by_rfc(rfc)
      Persona.get(:show_by_rfc, :rfc => rfc) if rfc 
  end

  def self.update_attributes!(attributes)
     self.put(attributes)
  end

  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end
end
