class Contacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "pr_contacto"
  #belongs_to :persona, class_name => "Persona", :foreign_key => "id_persona"
  belongs_to :persona
  belongs_to :tipo_contacto
  set_primary_key "id_contacto"
  

	# def persona
	#  return Persona.find(self.fk_persona)
	# end
	def correo
		find(:first, :select => "con_parametro", :conditions => ["fk_tipo = 2"])
	end

	def telefono_casa
		find(:first, :select => "con_parametro", :conditions => ["fk_tipo = 4"])
	end

	def celular
		find(:first, :select => "con_parametro", :conditions => ["fk_tipo = 1"])
	end

end
