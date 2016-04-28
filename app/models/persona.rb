##################################
# Modelo que conecta directamente a tabla de persona
#
##################################

class Persona < ActiveRecord::Base
  include UUIDHelper
  establish_connection "persona"
  set_table_name "pr_persona"
  set_primary_key "id_persona"
  has_many "contactos", :foreign_key =>"fk_persona"
  has_many "familiars",  :foreign_key => "persona_id"
  has_one "clave_elector", :foreign_key => "persona_id"

#  validates_format_of :per_curp, :with => /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/,
#    :allow_blank => true, :message => "Formato inválido"

  before_save :validates_curp, :if => "self.per_curp != nil"

  def validates_curp
    if self.per_curp && self.per_curp.size == 18
        self.per_curp = '' unless self.per_curp =~ /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/
    else
        self.per_curp=''
    end
    return true
  end

  ###### FUNCIONES QUE TRAEN Y GUADAN VALORES DE CONTACTO  ######

  def set_datos_contacto(tipo=nil, parametros={})
    @objeto_contacto = eval("(Contacto.#{tipo}.find(:first, :conditions => ['fk_persona = ?', self.id]))? Contacto.#{tipo}.find(:first, :conditions => ['fk_persona = ?', self.id]) : Contacto.#{tipo}.new(:fk_persona => self.id)") if tipo
    @objeto_contacto.update_attributes!(parametros) if @objeto_contacto && parametros
  end

  def get_datos_contacto(tipo=nil)
    eval("(self.contactos.#{tipo}.last)? self.contactos.#{tipo}.last.descripcion : nil") if tipo
  end

  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end

  def show_info
    nombre_completo + "|  CURP: #{self.per_curp} |  FECHA DE NAC: #{self.per_nacimiento}"
  end

  def get_datos_familiares(tipo_familiar=nil)
    if tipo = TipoFamiliar.find(:first, :conditions => ["clave = ?", tipo_familiar])
      @objeto = Familiar.find(:first, :conditions => ["persona_id = ? AND tipo_familiar_id = ?", self.id, tipo.id])
    else
      false
    end
  end

   def set_datos_familiares(tipo_familiar=nil, parametros={})
     if tipo = TipoFamiliar.find(:first, :conditions => ["clave = ?", tipo_familiar])
        @objeto_contacto = eval("(Familiar.find(:first, :conditions => ['persona_id = ? AND tipo_familiar_id = ?', self.id, tipo.id]))? Familiar.find(:first, :conditions => ['persona_id = ? AND tipo_familiar_id = ?', self.id, tipo.id]) : Familiar.new(:persona_id => self.id)") if tipo_familiar && tipo
        @objeto_contacto.tipo_familiar_id ||= tipo.id
        @objeto_contacto.update_attributes!(parametros) if @objeto_contacto && parametros
     end
   end

  def self.search(search)
    if search
      find(:all, :conditions => ['CONCAT(per_nombre, \' \' , per_paterno, \' \' , per_materno) LIKE ?', "%#{search}%"], :order => "per_paterno, per_materno, per_nombre", :limit => 25)
    else
      find(:all)
    end
  end

end
