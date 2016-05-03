######################################
# Controlador que administra a los defensores públicos
# 
######################################

class DefensoresController < ApplicationController
  require_role [:defensor, :jefedefensor]
  require_role :admin, :for => :destroy
   require_role :jefedefensor, :for => :actividad_semanal

  def index
      @defensores = Defensor.find(:all).paginate(:page => params[:page], :per_page => 25)
      @municipios = Municipio.chiapas.all
      render :partial => "list", :layout => "content"
  end

  def search
    @defensores = Defensor.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @defensor = (params[:id])? Defensor.find(params[:id]) : Defensor.new
      @persona = @defensor.persona
      @municipios = Municipio.chiapas.all
  end

   def save
      @defensor = (params[:id])? Defensor.find(params[:id]) : Defensor.new
      @defensor.update_attributes(params[:defensor])
      if params[:persona]
        @defensor.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
        @defensor.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
         ## Guarda datos de contacto personales ##
         if params[:contacto]
            @defensor.persona.set_datos_contacto('telefono_celular', :con_parametro => params[:contacto][:telefono_celular], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_celular] &&  params[:contacto][:telefono_celular].size > 0
            @defensor.persona.set_datos_contacto('telefono_casa', :con_parametro => params[:contacto][:telefono_casa], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_casa] &&  params[:contacto][:telefono_casa].size > 0
            @defensor.persona.set_datos_contacto('direccion', :con_parametro => params[:contacto][:direccion], :con_usu_modi => current_user.persona.id) if params[:contacto][:direccion] &&  params[:contacto][:direccion].size > 0
            @defensor.persona.set_datos_contacto('correo_electronico', :con_parametro => params[:contacto][:correo_electronico], :con_usu_modi => current_user.persona.id) if params[:contacto][:correo_electronico] &&  params[:contacto][:correo_electronico].size > 0
         end
     end
      @defensor.persona ||= Persona.new(params[:persona])
      @defensor.activo = (params[:defensor] && params[:defensor][:activo] == 'SI') ? true : false
      if @defensor.valid? && @defensor.persona.valid?
         @defensor.save && @defensor.persona.save
         flash[:notice] = "Defensor registrado correctamente"
         redirect_to :controller => "defensores"
      else
         @municipios = Municipio.chiapas.all
         render :action => "new_or_edit"
      end
    end

  def destroy
    @defensor = Defensor.find(params[:id])
    @tramites_defensor = Tramite.count(:defensor_id, :conditions => ["defensor_id = ? ", @defensor]) if @defensor
    @sucess = (@tramites_defensor && @tramites_defensor.size == 0)
    if @sucess && @defensor.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, cuenta con registros asociados, contacte al administrador"
    end
    redirect_to(:back)
  end

  def actividad_semanal
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]).sort{|a,b|a.actividad_desde_inicio_semana <=> b.actividad_desde_inicio_semana}
  end

  def list_tramites
    begin
      @defensor = Defensor.find(params[:id])
      @tramites =  Tramite.find(:all, :conditions => ["defensor_id = ?", @defensor]).paginate(:page => params[:page], :per_page => 25)
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index", :controller => "defensores"
    end
  end

end
