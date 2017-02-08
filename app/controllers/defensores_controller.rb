#########################################
# = Controlador que administra a los defensores públicos
# 
#########################################

class DefensoresController < ApplicationController
  require_role [:defensor, :jefedefensor]
  require_role :admin, :for => :destroy
   require_role :jefedefensor, :for => :actividad_semanal

  def index
      @defensores = Defensor.find(:all).paginate(:page => params[:page], :per_page => 25)
      @municipios = Municipio.chiapas.all
      render :partial => "list", :layout => "content"
  end

  # Búsqueda de defensores por nombre o apellidos
  def search
    @defensores = Defensor.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  # Registro o edición de defensores públicos
  def new_or_edit
      @defensor = (params[:id])? Defensor.find(params[:id]) : Defensor.new
      @persona = @defensor.persona
      @user = User.find_by_persona_id(@persona.id) if @persona
      @municipios = Municipio.chiapas.all
      @materias = Materia.all
  end

   def save
      @defensor = (params[:id])? Defensor.find(params[:id]) : Defensor.new
      @defensor.update_attributes(params[:defensor])
      if params.include?(:persona)
        @defensor.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
        @defensor.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
         ## Guarda datos de contacto personales ##
         save_persona(params, @defensor)

         if params.include?(:user)
            @user =  (params[:user].include?(:login) && params[:user][:login].size > 2)? User.find_by_login(params[:user][:login]) : nil
            @user ||= User.new
            @user.roles << Role.find_by_name("defensor")
            @user.persona_id = @defensor.persona
            @success = (@user) ? @user.update_attributes(params[:user]) : nil
            if @success && @user.save
              flash[:notice] = "Usuario creado"
            end
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
         @materias = Materia.all
         render :action => "new_or_edit"
      end
    end

  # Método que elimina registro de defensor, recibe como parámetro el id del registro
  def destroy
    @defensor = Defensor.find(params[:id])
    @tramites_defensor = Tramite.count(:defensor_id, :conditions => ["defensor_id = ? ", @defensor.id]) if @defensor
    @sucess = (@tramites_defensor && @tramites_defensor == 0)
    if @sucess && @defensor.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, cuenta con registros asociados, contacte al administrador"
    end
    redirect_to(:back)
  end

  # Muestra actividad semanal de los defensores
  def actividad_semanal
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]).sort{|a,b|a.actividad_desde_inicio_semana <=> b.actividad_desde_inicio_semana}
  end

  # selecciona el listado de todos los tramites
  def list_tramites
    begin
      @defensor = Defensor.find(params[:id])
      @tramites =  Tramite.find(:all, :conditions => ["defensor_id = ?", @defensor]).paginate(:page => params[:page], :per_page => 25)
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index", :controller => "defensores"
    end
  end

  # Filtra defensores de acuerdo a materia
  def get_defensor_por_materia
     case params
     when respond_to?(:audiencia_materia_id)
      @materia_id = params[:audiencia_materia_id]
     else
      @materia = Materia.find_by_descripcion("MIXTA")
     end
     if @materia && @materia.descripcion == "MIXTA"
       @adscripcion = Adscripcion.find(current_user.adscripcion ) if current_user && current_user.adscripcion
        @defensores = @adscripcion.defensores

      else
      @defensores = @materia = Materia.find(@materia_id).defensors
    end
    render :partial => "get_defensor_por_materia", :layout => "only_jquery"
  end

end
