######################################
# Controlador que hace operaciones basicas de las audiencias
# u orientaciones que los defensores dan al publico en general
######################################

class AudienciasController < ApplicationController
  before_filter :login_required, :except => 'get_datos_personales'
  
  def index
    @audiencias = Audiencia.find(:all, :conditions => ["fecha = ?", Time.now.strftime("%Y/%m/%d")])
    render :partial => "list", :layout => "content"
  end

  def search
    @audiencias = Audiencia.search(params[:search])
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @audiencia = (params[:id])? Audiencia.find(params[:id]) : Audiencia.new
      @audiencia.fecha ||= Time.now.strftime("%Y/%m/%d")
      @materias = Catalogo.materia.all
      @defensores = Defensor.find(:all, :conditions => ["activo = ?", true])
      @persona = @audiencia.persona
  end

  # Guarda registro
  def save
      @audiencia = (params[:id])? Audiencia.find(params[:id]) : Audiencia.new
      @audiencia.update_attributes(params[:audiencia])
      if params[:persona]
        @audiencia.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
        @audiencia.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
      end
      @audiencia.persona ||= Persona.new(params[:persona])
      if @audiencia.save && @audiencia.persona.save
        flash[:notice] = "Audiencia registrada correctamente"
        redirect_to :controller => "audiencias"
      else
        flash[:error] = "Registro no válido"
        render :action => "new_or_edit"
      end
  end

  def show
      select_object
  end

  # Imprime en formato pdf registro de audiencia/orientacion
  def print
        if (select_object) && (@audiencia.turno)
         param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
         #-- Parametros
         param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
         param["P_TURNO"]=(@audiencia.turno)? {:tipo=>"String", :valor=>@audiencia.turno} :  {:tipo=>"String", :valor=>"--"}
         param["P_SOLICITANTE"]=(@audiencia.persona) ? {:tipo=>"String", :valor=>@audiencia.persona.nombre_completo} : {:tipo=>"String", :valor=> "------"}
         param["P_FECHA"]= (@audiencia.fecha) ? {:tipo=>"String", :valor=>"#{@audiencia.fecha.strftime('%d DE %B DE %Y').upcase}"}: {:tipo=>"String", :valor=>""}
         param["P_OBSERVACIONES"]={:tipo=>"String", :valor=>clean_string(@audiencia.observaciones)}
         param["P_PROCEDENCIA"]={:tipo=>"String", :valor=>clean_string(@audiencia.procedencia)}
         param["P_ASUNTO"]={:tipo=>"String", :valor=>clean_string(@audiencia.asunto)}
         if File.exists?(REPORTS_DIR + "/ficha_atencion.jasper")
            send_doc_jdbc("ficha_atencion", "ficha_atencion", param, output_type = 'pdf')
         else
            flash[:error] = "archivo de reporte no existe"
            redirect_to :controller => "home"
        end
      else
          flash[:error] = "Error de parámetros"
          redirect_to :controller => "home"
    end
 end

 # Elimina registro de audiencia
  def destroy
    select_object
    if @audiencia.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "index"
  end

  # Función que despliega dinámicamente listado de turnos y defensores
  def monitor
      render :partial => "monitor", :layout => "only_javascript"
  end

  # Obtiene el valor de la asignación de defensores al público
  def get_last_attention
      @audiencias = Audiencia.find(:all, :conditions => ["defensor_id IS NOT NULL AND fecha = ?", Time.now.strftime("%Y/%m/%d")])
      return render(:partial => 'list_turnos', :layout => false) if request.xhr?
  end

  
private

def select_object
        begin
            @audiencia =  Audiencia.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            flash[:error] = "No se encontro tramite, verifique o contacte al administrador"
            redirect_to  :action => "index"
        end
end

#  def set_layout
#    (action_name == 'print')? 'pdf' : 'content'
#  end

end
