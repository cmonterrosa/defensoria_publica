class AudienciasController < ApplicationController
  before_filter :login_required
#  layout :set_layout

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
      @persona = @audiencia.persona
  end

  def save
    @audiencia = (params[:id])? Audiencia.find(params[:id]) : Audiencia.new
    @audiencia.update_attributes(params[:audiencia])
    @audiencia.persona = (params[:persona] && params[:persona][:per_curp]) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
    @audiencia.persona ||= Persona.new(params[:persona])
    if @audiencia.save && @audiencia.persona.save
      flash[:notice] = "Audiencia registrada correctamente"
      redirect_to :controller => "audiencias"
    end
  end

  def show
    @audiencia = Audiencia.find(params[:id])
  end

    def print
      if (@audiencia = Audiencia.find(params[:id])) && (@audiencia.turno)
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

  def destroy
    @audiencia = Audiencia.find(params[:id])
    if @audiencia.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "index"
  end

  def get_datos_personales
     if params[:persona_per_curp].size >= 15
      @persona = Persona.find(:first, :conditions => ["per_curp like ?", "#{params[:persona_per_curp]}%"])
      @persona ||= Persona.new
     end
     return render(:partial => 'datos_personales', :layout => false) if request.xhr?
  end

private

#  def set_layout
#    (action_name == 'print')? 'pdf' : 'content'
#  end

end
