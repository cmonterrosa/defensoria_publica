class PersonaWs <  ActiveResource::Base
  self.site = "http://localhost:3001/"
  self.user = "user"
  self.password = "secret"
  self.element_name = "personas"
  

  set_primary_key "id_persona"
  
  
  def self.find_by_curp(curp)
      self.get(:show_by_curp, :curp => curp) if curp
  end

  def self.find_by_rfc(rfc)
      self.get(:show_by_rfc, :rfc => rfc) if rfc
  end

  def update_attributes(attributes={})
      self.put(:update, self.id, attributes)
  end

  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end
end
