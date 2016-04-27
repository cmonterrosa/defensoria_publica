# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  include SendDocHelper
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  layout 'content', :except => [:sessions]
  
  def clean_string(string)
    (string) ? (return string.to_s.gsub(/\$/, '\$').gsub(/\"/, '\"')) : (return "")
  end

   def write_log(text=nil, user=nil)
    user = (user) ? user.nombre_completo : "DESCONOCIDO"
    text = (text) ? text.upcase : ""
    Rails.logger.info "=> (#{Time.now.strftime('%d/%m/%Y  %H:%M:%S')}" +  "/  USUARIO: #{user}) - " + text
    #Rails.logger.debug "=> (#{Time.now.strftime('%d/%m/%Y  %H:%M:%S')}" +  "/  USUARIO: #{user}) - " + text
  end

  def habil?(date=Time.now)
    habil = false
    if ((1..5)===date.wday)
      habil = true
    end
    return habil
  end

  def multiple_selected_id(relacion)
    if relacion.empty?
      @selected=[]
    else
      @selected=relacion.collect{|cat|cat.id}
    end
    return @selected
  end

  def save_persona(params={}, objeto=nil)
          if params[:persona] && objeto
            @participante = objeto
            @participante.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
            @participante.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
            ## Si no existe vamos a crear el objeto persona ##
            @participante.persona ||= Persona.new(:per_nombre => params[:persona][:per_nombre], :per_paterno => params[:persona][:per_paterno], :per_materno => params[:persona][:per_materno], :per_nacimiento => params[:persona][:per_nacimiento])
            if params[:contacto]
              @participante.persona.set_datos_contacto('telefono_celular', :con_parametro => params[:contacto][:telefono_celular], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_celular] &&  params[:contacto][:telefono_celular].size > 0
              @participante.persona.set_datos_contacto('telefono_casa', :con_parametro => params[:contacto][:telefono_casa], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_casa] &&  params[:contacto][:telefono_casa].size > 0
              @participante.persona.set_datos_contacto('direccion', :con_parametro => params[:contacto][:direccion], :con_usu_modi => current_user.persona.id) if params[:contacto][:direccion] &&  params[:contacto][:direccion].size > 0
              @participante.persona.set_datos_contacto('correo_electronico', :con_parametro => params[:contacto][:correo_electronico], :con_usu_modi => current_user.persona.id) if params[:contacto][:correo_electronico] &&  params[:contacto][:correo_electronico].size > 0
              @participante.persona.set_datos_contacto('direccion_laboral', :con_parametro => params[:contacto][:direccion_laboral], :con_usu_modi => current_user.persona.id) if params[:contacto][:direccion_laboral] &&  params[:contacto][:direccion_laboral].size > 0
              @participante.persona.set_datos_contacto('telefono_laboral', :con_parametro => params[:contacto][:telefono_laboral], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_laboral] &&  params[:contacto][:telefono_laboral].size > 0
          end
          @participante.persona.set_datos_familiares("padre", params[:padre]) if params[:padre]
          @participante.persona.set_datos_familiares("madre", params[:madre]) if params[:madre]
        end
    end

end
