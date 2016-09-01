######################################
# = Controlador que hace operaciones basicas de las audiencias
# u orientaciones que los defensores dan al publico en general
######################################

class AudienciasController < ApplicationController
  require_role [:defensor, :directivo, :admin, :recepcion], :except => 'get_datos_personales'

  # Listado de audiencias
  def index
    if current_user.has_role?(:directivo) || current_user.has_role?(:admin)
      adscripcion_conditions = (current_user.adscripcion) ? '' : "AND adscripcion_id=#{current_user.adscripcion.id}"
      @audiencias = Audiencia.find(:all, :conditions => ["DATE(fechahora_atencion) = ? #{adscripcion_conditions}", Time.now.strftime("%Y/%m/%d")], :order => "fechahora_atencion DESC").paginate(:page => params[:page], :per_page => 25)
   end
    @audiencias ||= Audiencia.find(:all, :conditions => ["DATE(fechahora_atencion) = ? #{adscripcion_conditions}", Time.now.strftime("%Y/%m/%d")], :order => "fechahora_atencion DESC").paginate(:page => params[:page], :per_page => 25)
    @audiencias_ids = @audiencias.collect{|a|a.id.to_i}.join(",")
    render :partial => "list", :layout => "content"
  end

  # Listado de reportes
  def reportes_index
   
  end

  # Devuelve seleccionar para busqueda
  def get_menu_opciones
    case params[:tipo]
    when 'persona'
        render :partial => "busqueda_por_persona", :layout => "only_jquery"
    when 'fechas'
        render :partial => "busqueda_por_fechas", :layout => "only_jquery"
    when 'defensor'
       @defensores_list = Defensor.find(:all, :conditions => ["persona_id IS NOT NULL"])
       @defensores = []
       @defensores_list.each do |d|
         @defensores << d if d.persona
       end
       render :partial => "busqueda_por_defensor", :layout => "only_jquery"
    when 'adscripcion'
        @adscripciones = Adscripcion.find :all
        render :partial => "busqueda_por_adscripcion"
    else
        render :text => ""
    end
  end

  # Búsqueda de audiencias
  def search
      if params[:fecha]
        @inicio = join_date(params[:fecha], :inicio)
        @fin = join_date(params[:fecha], :fin)
        if (@inicio && @fin) && (@fin >= @inicio)
            @audiencias = Audiencia.find(:all, :conditions => ["DATE(fechahora_atencion) between ? AND ?", @inicio, @fin], :order => "fechahora_atencion").paginate(:page => params[:page], :per_page => 25)
            @title = "PERIODO DEL : #{@inicio.strftime("%d de %B de %Y").upcase} AL #{@fin.strftime("%d de %B de %Y").upcase}"
        else
          @audiencias = Array.new
          flash[:error] = "Seleccione un rango de fechas valido"
        end
      else
        if params[:defensor].respond_to?(:size) && params[:defensor][:id]
            @defensor = Defensor.find(params[:defensor][:id])
            @title = "AUDIENCIAS DEL DEFENSOR #{(@defensor && @defensor.persona) ? @defensor.persona.nombre_completo : ''}"
            @audiencias = Audiencia.find(:all, :conditions => ["defensor_id = ?", @defensor.id]) if @defensor
        end
        if params[:adscripcion].respond_to?(:size) && params[:adscripcion][:id]
          @adscripcion = Adscripcion.find(params[:adscripcion][:id])
          @title = "AUDIENCIAS DE #{(@adscripcion)? @adscripcion.descripcion : ''}"
          @audiencias = Audiencia.find(:all, :conditions => ["adscripcion_id = ?", @adscripcion.id]) if @adscripcion
        end
        # Es una busqueda por texto
        @audiencias ||= Audiencia.search(params[:search], current_user)
        @audiencias = (@audiencias && !@audiencias.empty?)? @audiencias.paginate(:page => params[:page], :per_page => 25) : Array.new
      end
      @audiencias_ids = @audiencias.collect{|a|a.id.to_i}.join(",")
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
      @audiencia.adscripcion ||= current_user.adscripcion
      @audiencia.update_attributes(params[:audiencia])
      if params[:persona]
        @audiencia.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
        @audiencia.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
      end
      @audiencia.persona ||= Persona.new(params[:persona])
      if @audiencia.save && @audiencia.persona.valid?
        save_persona(params, @audiencia)
        flash[:notice] = "Audiencia registrada correctamente"
        redirect_to :controller => "audiencias"
      else
        @materias = Catalogo.materia.all
        @defensores = Defensor.find(:all, :conditions => ["activo = ?", true])
        flash[:error] = "Registro no válido"
        render :action => "new_or_edit"
      end
  end

 # Muestra detalle historico de orientaciones por persona
 def history_by_person
    if @persona = Persona.find(params[:id])
       @orientaciones = Audiencia.find(:all, :conditions => ["persona_id = ?", @persona.id], :order=> "created_at DESC")
       render :partial => "history_by_person", :layout => "content"
    else
      flash[:error] = "Persona no encontrada, verifique o contacte al administrador"
      redirect_to(:back)
    end
 end

 # Metodo que establece bandera de atendido a true o false dependiendo las condiciones
 def mark_as_attended
    if select_object
        if @audiencia.defensor.persona == current_user.persona
            @audiencia.update_attributes!(:atendido => true)
            flash[:notice] = "Registro atendido correctamente"
        end
    else
        flash[:warning] = "No pudo encontrarse objeto, verifique"
    end
    redirect_to(:back)
 end

 # Imprime el historico de orientaciones por persona
 def print_history_by_person
     if @persona = Persona.find(params[:id])
       @orientaciones = Audiencia.find(:all, :conditions => ["persona_id = ?", @persona.id], :order=> "created_at DESC")
       render :partial => "history_by_person", :layout => "pdf"
    else
      flash[:error] = "Persona no encontrada, verifique o contacte al administrador"
      redirect_to(:back)
    end
 end


  # Muestra detalle de la orientacion
  def show
      select_object
  end

  # Imprime listado de audiencias
  def print_list
    @audiencias = Audiencia.find(params[:audiencias_ids].split(","))
    render :partial => "list_essentials_print", :layout => "pdf"
  end

  # Imprime en formato pdf registro de audiencia/orientacion
  def print_ficha
        if (select_object) && (@audiencia.turno)
         param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
         param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
         param["P_TURNO"]=(@audiencia.turno)? {:tipo=>"String", :valor=>@audiencia.turno} :  {:tipo=>"String", :valor=>"--"}
         if @audiencia.persona
            param["P_SOLICITANTE"]=(@audiencia.persona) ? {:tipo=>"String", :valor=>@audiencia.persona.nombre_completo} : {:tipo=>"String", :valor=> "------"}
              if @extension = ExtensionPersona.find_by_persona_id(@audiencia.persona)
                    param["P_SEXO"] = {:tipo=>"String", :valor=>@extension.sexo}
              end
              param["P_DOMICILIO"] = {:tipo=>"String", :valor=>@audiencia.persona.get_datos_contacto('direccion')}
              param["P_TELEFONO_CASA"] = {:tipo=>"String", :valor=>@audiencia.persona.get_datos_contacto('telefono_casa')}
              param["P_TELEFONO_TRABAJO"] = {:tipo=>"String", :valor=>@audiencia.persona.get_datos_contacto('telefono_laboral')}
              param["P_TELEFONO_CELULAR"] = {:tipo=>"String", :valor=>@audiencia.persona.get_datos_contacto('telefono_celular')}
         end
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
      @adscripcion_id = (params[:user_id] && (@user = User.find(params[:user_id]))) ? @user.adscripcion_id : nil
      @adscripcion_condition = (@adscripcion_id) ? "AND adscripcion_id = #{@adscripcion_id} " : ''
      @audiencias = Audiencia.find(:all, :conditions => ["defensor_id IS NOT NULL AND fecha = ? #{@adscripcion_condition}", Time.now.strftime("%Y/%m/%d")])
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

  def set_layout
    (action_name == 'print_history_by_person')? 'pdf' : 'content'
  end

end

