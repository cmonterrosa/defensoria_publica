#####################################
# Modelo que consulta los datos de contacto de las personas
#
#####################################

class Contacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "pr_contacto"
  belongs_to :persona, :foreign_key => "fk_persona"
  belongs_to :tipo_contacto, :foreign_key => "fk_tipo"
  set_primary_key "id_contacto"

  named_scope :telefono_celular, :conditions => {:fk_tipo => 1}
  named_scope :correo_electronico, :conditions => {:fk_tipo => 2}
  named_scope :direccion, :conditions => {:fk_tipo => 3}
  named_scope :telefono_casa, :conditions => {:fk_tipo => 4}
  named_scope :direccion_laboral, :conditions => {:fk_tipo => 5}
  named_scope :telefono_laboral, :conditions => {:fk_tipo => 6}

  before_create :time_stamping, :make_active
  before_save :time_stamping, :make_active
  before_save :check_id_integrity
  
  def check_id_integrity
    begin
      self.id = 1 if Contacto.count(:id_contacto) == 0
      self.id ||= (Contacto.maximum(:id_contacto) > 0) ? Contacto.maximum(:id_contacto) + 1 : 1
    rescue
      puts("=> NO SE PUDO CHECAR LA INTEGRIDAD DEL REGISTRO DE CONTACTO")
    end
  end

  def make_active
    self.con_activo_reg ||= 1
  end

  def time_stamping
    self.con_modi = Time.now
    self.con_alta ||= Time.now
  end

  def descripcion
    self.con_parametro
  end

end
