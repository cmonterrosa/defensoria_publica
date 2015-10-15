class Persona < ActiveRecord::Base
  set_primary_key "id_persona"
  

  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end
end
