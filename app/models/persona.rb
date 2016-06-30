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
  has_one "extension_persona", :foreign_key => "persona_id"

#  validates_format_of :per_curp, :with => /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/,
#    :allow_blank => true, :message => "Formato inválido"

  before_save :validates_curp, :if => "self.per_curp != nil"

  def validates_curp
    success = (self.per_curp && self.per_curp.size == 18)
    if success && self.per_curp=~ /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/
        true
    end
  end

  # Calcula la edad de la persona
   def edad
      self.per_nacimiento ? ((DateTime.now -  self.per_nacimiento) / 365.25).to_i : nil
   end

  ###### FUNCIONES QUE TRAEN Y GUARDAN VALORES DE CONTACTO  ######

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

   # Devuelve el numero de orientaciones fisicas que se le han brindado en el IDP
   def numero_orientaciones
     (self.id) ?Audiencia.count(:id, :conditions => ["persona_id = ?", self.id]) : 0
   end

   
  def self.search(search)
    if search
      find(:all, :conditions => ['CONCAT(per_nombre, \' \' , per_paterno, \' \' , per_materno) LIKE ?', "%#{search}%"], :order => "per_paterno, per_materno, per_nombre", :limit => 25)
    else
      find(:all)
    end
  end

  # Prepara registro con sus correlaciones en distintos modelos
  def prepare_row(params={}, current_user=nil, objeto=nil)
          if params[:persona]
            @persona = objeto.persona if (objeto)
            @persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
            @persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
            anio = params[:persona]["per_nacimiento(1i)"]
            mes= params[:persona]["per_nacimiento(2i)"]
            dia=params[:persona]["per_nacimiento(3i)"]
            date = Date.new(anio.to_i,mes.to_i,dia.to_i)
            ## Si no existe vamos a crear el objeto persona ##
            @persona ||= Persona.new
            @persona.update_attributes(:per_nombre => params[:persona][:per_nombre], :per_paterno => params[:persona][:per_paterno], :per_materno => params[:persona][:per_materno], :per_nacimiento => date)
            if params[:contacto]
              @persona.set_datos_contacto('telefono_celular', :con_parametro => params[:contacto][:telefono_celular], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_celular] &&  params[:contacto][:telefono_celular].size > 0
              @persona.set_datos_contacto('telefono_casa', :con_parametro => params[:contacto][:telefono_casa], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_casa] &&  params[:contacto][:telefono_casa].size > 0
              @persona.set_datos_contacto('direccion', :con_parametro => params[:contacto][:direccion], :con_usu_modi => current_user.persona.id) if params[:contacto][:direccion] &&  params[:contacto][:direccion].size > 0
              @persona.set_datos_contacto('correo_electronico', :con_parametro => params[:contacto][:correo_electronico], :con_usu_modi => current_user.persona.id) if params[:contacto][:correo_electronico] &&  params[:contacto][:correo_electronico].size > 0
              @persona.set_datos_contacto('direccion_laboral', :con_parametro => params[:contacto][:direccion_laboral], :con_usu_modi => current_user.persona.id) if params[:contacto][:direccion_laboral] &&  params[:contacto][:direccion_laboral].size > 0
              @persona.set_datos_contacto('telefono_laboral', :con_parametro => params[:contacto][:telefono_laboral], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_laboral] &&  params[:contacto][:telefono_laboral].size > 0
            end
            if params[:clave_elector] && params[:clave_elector][:descripcion].size > 0
              @clave_elector = (@persona.clave_elector) ? @persona.clave_elector : ClaveElector.new(:persona_id => @persona.id )
              @clave_elector.descripcion ||= params[:clave_elector][:descripcion]
              @clave_elector.save
            end
            if params[:extension] && params[:extension].size > 0
              @extension = (@persona.extension_persona) ? @persona.extension_persona : ExtensionPersona.new(:persona_id => @persona.id)
              @extension.update_attributes!(params[:extension])
           end
          @persona.set_datos_familiares("padre", params[:padre]) if params[:padre]
          @persona.set_datos_familiares("madre", params[:madre]) if params[:madre]
        end
    end


end
