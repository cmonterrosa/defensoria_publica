class Persona < ActiveRecord::Base
  include UUIDHelper
  #set_table_name "pr_persona"
  set_primary_key "id_persona"
  
  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end
end
