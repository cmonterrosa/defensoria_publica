class Contacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "pr_contacto"
  #belongs_to :persona, class_name => "Persona", :foreign_key => "id_persona"
  belongs_to :persona, :foreign_key => "fk_persona"
  belongs_to :tipo_contacto
  set_primary_key "id_contacto"

  named_scope :telefono_celular, :conditions => {:fk_tipo => 1}
  named_scope :correo_electronico, :conditions => {:fk_tipo => 2}
  named_scope :direccion, :conditions => {:fk_tipo => 3}
  named_scope :telefono_casa, :conditions => {:fk_tipo => 2}

  before_create :time_stamping, :make_active


  def make_active
    self.con_activo_reg ||= 1
  end

  def time_stamping
    self.con_modi ||= Time.now
  end

  def descripcion
    self.con_parametro
  end

	# def persona
	#  return Persona.find(self.fk_persona)
	# end
#	def correo
#		find(:first, :select => "con_parametro", :conditions => ["fk_tipo = 2"])
#	end
#
#	def telefono_casa
#		find(:first, :select => "con_parametro", :conditions => ["fk_tipo = 4"])
#	end
#
#	def celular
#		find(:first, :select => "con_parametro", :conditions => ["fk_tipo = 1"])
#	end

end
