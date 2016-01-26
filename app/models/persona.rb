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

#  validates_format_of :per_curp, :with => /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/,
#    :allow_blank => true, :message => "Formato inválido"

  before_save :validates_curp

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
    case tipo
        when 'telefono_celular'
                  @objeto_contacto = (Contacto.find(:first, :conditions => ["fk_tipo = 1 AND fk_persona= ?", self.id])) ? Contacto.find(:first, :conditions => ["fk_persona = ?", self.id]) : Contacto.new(:fk_persona => self.id, :fk_tipo => 1)
        when 'correo_electronico'
                  @objeto_contacto = (Contacto.find(:first, :conditions => ["fk_tipo = 2 AND fk_persona = ?", self.id])) ? Contacto.find(:first, :conditions => ["fk_persona = ?", self.id]) : Contacto.new(:fk_persona => self.id, :fk_tipo => 2)
        when 'direccion'
                  @objeto_contacto = (Contacto.find(:first, :conditions => ["fk_tipo = 3 AND fk_persona = ?", self.id])) ? Contacto.find(:first, :conditions => ["fk_persona = ?", self.id]) : Contacto.new(:fk_persona => self.id, :fk_tipo => 3)
        when 'telefono_casa'
                 @objeto_contacto = (Contacto.find(:first, :conditions => ["fk_tipo = 4 AND fk_persona = ?", self.id])) ? Contacto.find(:first, :conditions => ["fk_persona = ?", self.id]) : Contacto.new(:fk_persona => self.id, :fk_tipo => 4)
     else
          return false
     end
     if @objeto_contacto
        @objeto_contacto.update_attributes(parametros)
        @objeto_contacto.save
     end
  end

  def get_datos_contacto(tipo=nil)
    if !self.contactos.empty?
        case tipo
            when 'telefono_celular'
                 self.contactos.telefono_celular.last.descripcion if self.contactos.telefono_celular.last
            when 'correo_electronico'
                 self.contactos.correo_electronico.last.descripcion if self.contactos.correo_electronico.last
            when 'direccion'
                 self.contactos.direccion.last.descripcion if self.contactos.direccion.last
            when 'telefono_casa'
                 self.contactos.telefono_casa.last.descripcion if self.contactos.telefono_casa.last
          else
              return false
          end
    end
  end


  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end

  def nombre_curp
    nombre_completo + "| #{self.per_curp}"
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['CONCAT(per_nombre, \' \' , per_paterno, \' \' , per_materno) LIKE ?', "%#{search}%"], :order => "per_paterno, per_materno, per_nombre", :limit => 25)
    else
      find(:all)
    end
  end

end
